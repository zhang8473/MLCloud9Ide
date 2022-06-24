Install npm and then install
`npm install express --no-save`

Put the following command into `crontab -e` 
`@reboot cd <home_path>/MLCloud9Ide/Pac/ && node server.js &`

System Setting:
Network Proxy -> Automatic
`http://127.0.0.1:10000/my.pac`
