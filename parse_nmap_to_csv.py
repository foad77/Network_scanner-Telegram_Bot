import xml.etree.ElementTree as ET
import csv
import sys
from datetime import datetime
import requests
import yaml

def load_config(config_file='config.yaml'):
    with open(config_file, 'r') as file:
        return yaml.safe_load(file)

def send_telegram_message(token, chat_id, message):
    """Send a message via Telegram bot."""
    url = f'https://api.telegram.org/bot{token}/sendMessage'
    data = {'chat_id': chat_id, 'text': message}
    response = requests.post(url, data=data)
    print("Message sent to Telegram:", response.text)

def send_telegram_document(token, chat_id, file_path):
    """Send a document via Telegram bot."""
    url = f'https://api.telegram.org/bot{token}/sendDocument'
    files = {'document': open(file_path, 'rb')}
    data = {'chat_id': chat_id}
    response = requests.post(url, data=data, files=files)
    print("Document sent to Telegram:", response.text)

def parse_nmap_xml_to_csv(xml_file, scan_flag):
    config = load_config()
    token = config['telegram']['token']
    chat_id = config['telegram']['chat_id']

    date_time = datetime.now().strftime("D_%m_%d_T_%H_%M")
    csv_file = f"LANscanResult_{date_time}_{scan_flag}.csv"
    
    tree = ET.parse(xml_file)
    root = tree.getroot()

    headers = set()
    for host in root.findall('./host'):
        for address in host.findall('.//address'):
            headers.add(address.get('addrtype', '') + ' Address')
        for port in host.findall('.//port'):
            headers.add('Port ' + port.get('portid') + ' ' + port.find('.//state').get('state', ''))
        for osmatch in host.findall('.//os/osmatch'):
            headers.add('OS Match')

    headers = sorted(headers)

    with open(csv_file, 'w', newline='') as csvfile:
        writer = csv.DictWriter(csvfile, fieldnames=headers)
        writer.writeheader()

        for host in root.findall('./host'):
            row_data = {}
            for address in host.findall('.//address'):
                addr_type = address.get('addrtype', '') + ' Address'
                row_data[addr_type] = address.get('addr', 'N/A')
            for port in host.findall('.//port'):
                port_description = 'Port ' + port.get('portid') + ' ' + port.find('.//state').get('state', '')
                row_data[port_description] = port.find('.//service').get('name', 'Unknown service')
            for osmatch in host.findall('.//os/osmatch'):
                row_data['OS Match'] = osmatch.get('name', 'N/A')

            writer.writerow(row_data)

    # Send notification and the CSV report via Telegram
    message = f"The scan finished at {date_time}, and the result is saved in {csv_file}"
    send_telegram_message(token, chat_id, message)
    send_telegram_document(token, chat_id, csv_file)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 parse_nmap_to_csv.py <scan_flag>")
    else:
        scan_flag = sys.argv[1]
        parse_nmap_xml_to_csv('LANscanResult.xml', scan_flag)
