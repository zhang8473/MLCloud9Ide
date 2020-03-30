FROM python:3.8-slim

COPY requirements.txt .
# Install system packages
RUN Cloud9Deps='build-essential g++ libssl-dev python2.7 apache2-utils libxml2-dev sshfs wget' &&\
    apt-get update -yq &&\
    apt-get install -yq curl zip $Cloud9Deps tmux libgomp1 &&\
    pip3 install --upgrade pip&&\
    pip3 install flask redis orderedset numpy xgboost scikit-learn gensim>=3.7.2 aenum elasticsearch &&\
    pip3 install -r requirements.txt&&\
# config jupyter to no password
    mkdir ~/.jupyter &&\
    echo "c.NotebookApp.token = u''" >> ~/.jupyter/jupyter_notebook_config.py &&\
# Install Node.js
    curl -sL https://deb.nodesource.com/setup_6.x | bash - &&\
    apt-get install -y nodejs git &&\
# Install Cloud9
    git clone https://github.com/c9/core.git /opt/cloud9 &&\
    cd /opt/cloud9 &&\
    scripts/install-sdk.sh &&\
# Install supervisord for Python3
    git clone https://github.com/orgsea/supervisor-py3k.git /opt/supervisord &&\
    cd /opt/supervisord &&\
    python setup.py install &&\
    cp supervisor/version.txt /usr/local/lib/python3.6/site-packages/supervisor-3.0b2.dev0-py3.6.egg/supervisor/ &&\
# Install newest version of xgboost
    git clone --recursive https://github.com/dmlc/xgboost /opt/xgboost &&\
    cd /opt/xgboost &&\
    ./build.sh &&\
# Tweak standlone.js conf
    sed -i -e 's_127.0.0.1_0.0.0.0_g' /opt/cloud9/configs/standalone.js &&\
    apt-get purge -y --auto-remove $Cloud9Deps &&\
    apt-get autoremove -yq && apt-get autoclean -y && apt-get clean -y &&\
    rm -rf requirements.txt /var/lib/apt/lists/* /tmp/* /var/tmp/* &&\
# make working dir
    mkdir -p /workspace/

ADD notebook.sh /
COPY supervisord.conf /etc/supervisord.conf
ADD https://github.com/lancopku/pkuseg-python/releases/download/v0.0.16/mixed.zip /usr/local/lib/python3.8/site-packages/pkuseg-0.0.22-py3.8-linux-x86_64.egg/pkuseg/models/default/
RUN cd /usr/local/lib/python3.8/site-packages/pkuseg-0.0.22-py3.8-linux-x86_64.egg/pkuseg/models/default/ &&\
    unzip pkuseg-mixed.zip &&\
    rm pkuseg-mixed.zip

ENV PYTHONPATH /opt/xgboost/python-package:$PYTHONPATH NOMINATIM_SERVER=nominatim.openstreetmap.org

EXPOSE 80
EXPOSE 8888

ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
