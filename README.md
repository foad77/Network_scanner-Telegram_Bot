# Network_scanner-Telegram_Bot

This project consists of a Bash script and a Python script that together perform various network scans and report the results to a Telegram bot. The scans can be customized, and the results are sent in an Excel file format.

**Scan Types**

1. ARP Scan: Quickly list all active IPs on your local network.
2. Ping Scan (-sn): Quick check if hosts are online.
3. list Scan (-sL): Resolves IP addresses to hostnames.
4. Quick Scan (-T4 -F): Scans top 100 ports quickly.
5. Port Scan (-p): Scans specific ports or full range.
6. Service Version Detection (-sV): Detects services running on open ports.
7. OS Detection (-O): Attempts to determine the operating system.
8. Aggressive Scan (-A): Comprehensive scan including OS, version detection, and script scanning.
9. Full Scan with All Advanced Features (-p1-65535 -T4 -A --version-all -sC): Most detailed scan of every port and feature.

## Prerequisites

Ensure you have the following installed on your system:

- Python 3.10.10
- `yq` for YAML processing in the Bash script
- Required Python packages (listed in `requirements.txt`)


### Setting Up a Telegram Bot

To create a Telegram bot and obtain the necessary credentials, follow these steps:

1. Open Telegram and search for the BotFather.

2. Start a chat with the BotFather and send `/start`.

3. Create a new bot by sending `/newbot` and follow the instructions to set the bot name and username.

4. After creating the bot, you will receive a token. Save this token as `telegram_token` in your `config.yaml`.

5. Get your chat ID by starting a chat with your bot and sending any message. Open the following URL in your browser: `https://api.telegram.org/bot<your-telegram-bot-token>/getUpdates`. Replace `<your-telegram-bot-token>` with your actual bot token. Look for the `chat` object in the response to find your chat ID.
For a more detailed tutorial on creating a Telegram bot and obtaining the token and chat ID, refer to [this tutorial](https://core.telegram.org/bots#3-how-do-i-create-a-bot).

### Editing the config.yaml file
```sh        
token: 'your_telegram_bot_token'   # for example: '6357833747:AAG0fz5DvgyJRk6tGHpSpwxSfJktS2R_6W'
chat_id: 'your_telegram_chat_id'   # for example: '65442345'
```
### Installing `yq`

#### On macOS:
```sh
brew install yq
```
### On Linux:

```sh
$ sudo apt-get install -y jq
```
## or

```sh
$ sudo wget https://github.com/mikefarah/yq/releases/download/v4.25.2/yq_linux_amd64 -O /usr/bin/yq
$ sudo chmod +x /usr/bin/yq
```


### Installing Python Packages

Ensure you have Python 3.10.10 installed. Then, install the required Python packages using pip:

```sh
pip install -r requirements.txt
```

## Running the Script
Go to the directory where the files are . i.e., cd ...
then give the program execution permission:

```sh
chmod +x network_scan.sh
```

To perform a network scan and send the results to a Telegram bot, execute the Bash script:

```sh
$ ./network_scan.sh
```
