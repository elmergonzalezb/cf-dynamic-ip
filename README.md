# cf-dynamic-ip
### 1. install jq
> sudo apt install jq

### 2. create Cloudflare API token
![](/images/api.png)
### 3. get zoneid
   * go to https://dash.cloudflare.com/ and select domain you want to use
   * scroll down and see bottom right corner  
![](/images/zoneid.png)
### 4. put API token and zoneid inside *secret.key* file
### 5. put domain you want to modify inside *domain.lst*
   ex1. test.domain.com true  
   ex2. test2.domain.com false  
   true means you want to use proxy  
   false will reveal your origin IP  
### 6. make sure *secret.key* and *domain.lst* are in the same folder as *run.sh*
### 7. make run.sh executable
> sudo chmod +x run.sh  
### 8. open crontab
> crontab -e
### 9. put this inside crontab, it will update your IP every 30 minutes.
> */30 * * * * /path/to/run.sh
