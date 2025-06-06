Install npm and then install
`npm install express --no-save`

Put the following command into `crontab -e` 
`@reboot cd <home_path>/MLCloud9Ide/Pac/ && node server.js &`

System Setting:
Network Proxy -> Automatic
`http://127.0.0.1:10000/my.pac`

## How to Reinstall nvidia driver
1. Uninstall all
`sudo dpkg -P $(dpkg -l | grep nvidia | awk '{print $2}')`
2. For Ubuntu 22.04 x86_64. [Install Guide](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#network-repo-installation-for-ubuntu):
   1. `wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb`
   2. `sudo dpkg -i cuda-keyring_1.1-1_all.deb`
   3. `echo "deb [signed-by=/usr/share/keyrings/cuda-archive-keyring.gpg] https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64 /" | sudo tee /etc/apt/sources.list.d/cuda-ubuntu2204-x86_64.list`
   4. `sudo apt-get update`
   5. `sudo apt-get -y install cuda`

## Install container runtime on every node
[Install container runtime](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
```
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
sudo nvidia-ctk runtime configure --runtime=containerd
sudo systemctl restart containerd

## About dual card
1. `export TORCH_CUDA_ARCH_LIST="8.0"` to disable the old card, such as `pip install -v gptqmodel`