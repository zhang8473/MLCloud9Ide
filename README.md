# MLCloud9IDE
A Cloud9 IDE that provides packages for machine learning

# Build
`docker build -t masterid/mlcloud9ide .` -f Dockerfile_Jupyter

# To run
`docker run -v /local/path/:/workdir/ -p 8800:80 -p 9900:9000 -e ACCESS_KEY=username -e SECRET_KEY=password --name ide -t -d masterid/mlcloud9ide`
