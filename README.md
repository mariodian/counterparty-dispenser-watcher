## About The Project
Monitor Counterparty network for new asset dispensers. 

Get a notificaion via [Pushover](https://pushover.net) (paid service) or email (need to be configured separately to send emails remotely).

## Getting Started

To get a local copy up and running follow these simple steps.

### Prerequisites

In order to easily parse json responses from counterparty API, we need to install `jq` first.
* Install on Debian based distros:
  ```sh
  sudo apt update && sudo apt install jq
  ```
* Install on MacOS using brew:
  ```sh
  brew install jq
  ```

### Installation

If you have `jq` installed follow these steps.
1. Clone the repository:
   ```sh
   git clone https://github.com/mariodian/counterparty-dispenser-watcher.git
   ```
1. Go to the repo directory:
   ```sh
   cd counterparty-dispenser-watcher
   ```
1. Copy the content of `.env` to `.env.local` and edit according to your needs using your preferred text editor:
   ```sh
   cp .env .env.local
   ```
1. Edit `assets.txt` according to your needs. Each asset names goes on a new line.
1. If you want to be notified about new dispensers via email outside of your local machine, you need to setup postfix. Unfortunatelly, that's beyond the scope of this tutorial. I highly recommend using [Pushover](https://pushover.net) instead.

## Usage

### Run the script manually
To check if the script works run the following:
   ```sh
   ./watcher.sh
   ```

## Run the script automatically via cron
You will most likely want to check for new dispensers automatically. You can do so via cron.
1. Edit crontab:
   ```sh
   crontab -e
   ```
1. Add the following line to run every 10 minutes (edit the path according to your setup):
   ```sh
   */10 * * * * /home/<username>/<path to counterparty-dispenser-watcher dir>/watcher.sh > /dev/null 2>&1
   ```
1. Make sure the line was added correctly:
   ```sh
   crontab -l
   ```

## Donation
If you find this script useful, feel free to donate either bitcoin or counterparty assets to [bc1qfzfjr4e4wsm97erhdj9lnfaf6jeh4m0vunmsv0](https://xchain.io/address/bc1qfzfjr4e4wsm97erhdj9lnfaf6jeh4m0vunmsv0). 

Thank you!
