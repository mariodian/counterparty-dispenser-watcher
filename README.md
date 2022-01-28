# counterparty-dispenser-watcher
Monitoring changes in Counterparty dispensers.

## How to set up
- Edit `.env.local` according to your needs.
- Add Counterparty asseet names to `assets.txt`. Each asset goes on new new.

## How to run
Run `./watcher.sh` in your console. 

In case it can't execute, change the permissions first: `chmod u+x watcher.sh`

### Set up cron
To run the script automatically via cron every 10 minutes, add the following line to crontab (via `crontab -e`):

`*/10 * * * * /home/tyour user/path to watcher.sh > /dev/null 2>&1`

## Donation
If you find this script useful, feel free to donate either bitcoin or counterparty assets to [bc1qfzfjr4e4wsm97erhdj9lnfaf6jeh4m0vunmsv0](https://xchain.io/address/bc1qfzfjr4e4wsm97erhdj9lnfaf6jeh4m0vunmsv0). 

Thank you!
