# Ubuntu 20.04 Customization

## Must be backed-up manually

### MongoDB Compass
All configurations are saved in
`~/.config/MongoDB\ Compass/`

### Redis configs
Click "Export Connections" on RDM.

### MongoDB data
MongoDB data ownership is 'root'. So it must be copied by `sudo`.

## Must NOT be backed-up
### Sogoupinyin
 Do not use old config files. It will cause system stuck during startup

## Configrations after system installation
* Audio
 Add the following line to `/etc/modprobe.d/alsa-base.conf`
 `options snd-hda-intel model=alc233-eapd`
 Maybe:
 1. Install `sudo apt install alsa-tools-gui`
 2. Run `hdajackretask`
 3. Overwrite Black Mic, Front side with Microphone
* Automount ntfs:
 Add the following configs to /etc/fstab
 ```
 # Windows
UUID=783870F73870B62A /media/jinzhong/Windows/ ntfs rw,auto,users,exec,nls=utf8,umask=003,gid=1000,uid=1000    0   0
 ```

* Allow Thunderbird to access mounted disks
In case the thunderbird is installed by snap, go to snap-store/installed/thunderbird/permissions and allow read/write access to removable devices.


* System Load Indicator on top bar
`sudo apt install indicator-multiload`

* Hardware tempure sensors
```
sudo apt-get install lm-sensors hddtemp
sudo sensors-detect
sensors
sudo apt install psensor
```

* oh-my-zsh
  1. Backup .oh-my-zsh/:
  `mv .oh-my-zsh/ .oh-my-zsh-a`
  2. Download oh-my-zsh [installation script](https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) and run.
  3. Get configurations back:
  ```
  mv .zshrc.pre-oh-my-zsh .zshrc
  mv .oh-my-zsh-a/ .oh-my-zsh
  ```
* GitHub
[在 Git 中缓存 GitHub 凭据](https://docs.github.com/cn/free-pro-team@latest/github/using-git/caching-your-github-credentials-in-git)
```
git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=36000000'
```
