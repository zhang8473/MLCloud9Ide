#!/bin/bash

# Strict mode
set -euo pipefail
IFS=$'\n\t'

# Set configuration defaults
: ${CERTFILE_OPTION:=""}
: ${PASSWORD:=""}
: ${PEM_FILE:="/key.pem"}
: ${USE_HTTP:=0}

if [ $USE_HTTP -ne 0 ]; then
  : ${CERTFILE_OPTION=""}
else
  # Create a self signed certificate for the user if one doesn't exist
  if [ ! -f $PEM_FILE ]; then
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $PEM_FILE -out $PEM_FILE \
      -subj "/C=XX/ST=XX/L=XX/O=dockergenerated/CN=dockergenerated"
    : ${CERTFILE_OPTION="--certfile=$PEM_FILE"}
  fi
fi

# Create the hash to pass to the IPython notebook, but don't export it so it doesn't appear
# as an environment variable within IPython kernels themselves
HASH=$(python3 -c "from IPython.lib import passwd; print(passwd('${PASSWORD}'))")
unset PASSWORD

jupyter notebook --no-browser --port 8888 --ip=0.0.0.0 $CERTFILE_OPTION --NotebookApp.password="$HASH" --allow-root

unset HASH
