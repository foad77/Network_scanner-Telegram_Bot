# Network_scanner-Telegram_Bot

This project consists of a Bash script and a Python script that together perform various network scans and report the results to a Telegram bot. The scans can be customized, and the results are sent in an Excel file format.

## Prerequisites

Ensure you have the following installed on your system:

- Bash
- Python 3.10.10
- `yq` for YAML processing in the Bash script
- Required Python packages (listed in `requirements.txt`)

### Installing `yq`

#### On macOS:

```sh
#### brew install yq
On Linux:
$ sudo apt-get install -y jq
$ sudo wget https://github.com/mikefarah/yq/releases/download/v4.25.2/yq_linux_amd64 -O /usr/bin/yq
$ sudo chmod +x /usr/bin/yq


Installing Python Packages

Ensure you have Python 3.10.10 installed. Then, install the required Python packages using pip:

sh

$ pip install -r requirements.txt

Running the Script

To perform a network scan and send the results to a Telegram bot, execute the Bash script:

sh

$ ./network_scan.sh
