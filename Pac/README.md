Build:
`docker build -t local_file_server .`

Run:
`docker run -d -p 10000:10000 --name pac_server local_file_server`

System Setting:
Network Proxy -> Automatic
`http://127.0.0.1:10000/my.pac`
