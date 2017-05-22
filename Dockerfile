FROM python:3-slim

# Install system packages
RUN Cloud9Deps='build-essential g++ libssl-dev python2.7 apache2-utils libxml2-dev sshfs wget' &&\
    apt-get update -yq &&\
    apt-get install -yq curl zip $Cloud9Deps tmux libgomp1 &&\
    pip3 install --upgrade pip &&\
    pip3 install numpy==1.11.2 scipy==0.18.1 sklearn tornado tinys3 influxdb redis pandas apscheduler==3.3.1 jsonschema bottleneck&&\
# Install Node.js
    curl -sL https://deb.nodesource.com/setup_6.x | bash - &&\
    apt-get install -y nodejs git &&\
# Install Cloud9
    git clone https://github.com/c9/core.git /opt/cloud9 &&\
    cd /opt/cloud9 &&\
    scripts/install-sdk.sh &&\
# Install librdkafka
    wget https://github.com/edenhill/librdkafka/archive/v0.9.2.tar.gz &&\
    tar -xzvf v0.9.2.tar.gz &&\
    cd librdkafka-0.9.2/ &&\
    ./configure &&\
    make &&\
    make install &&\
    pip3 install confluent-kafka &&\
# install xgboost
    git clone --recursive https://github.com/dmlc/xgboost /opt/xgboost &&\
    cd /opt/xgboost &&\
    ./build.sh &&\
# Tweak standlone.js conf
    sed -i -e 's_127.0.0.1_0.0.0.0_g' /opt/cloud9/configs/standalone.js &&\
    apt-get purge -y --auto-remove $Cloud9Deps &&\
    apt-get autoremove -yq && apt-get autoclean -y && apt-get clean -y &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* &&\
# make working dir
    mkdir -p /workspace/


ENV PYTHONPATH /opt/xgboost/python-package:$PYTHONPATH

EXPOSE 80

CMD node /opt/cloud9/server.js --listen 0.0.0.0 --port 80 --auth $ACCESS_KEY:$SECRET_KEY -w /workspace/
