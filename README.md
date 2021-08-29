# Welcome to dockermgr REPLACE_APPNAME installer 👋
  
## REPLACE_APPNAME README  
  
### Requires scripts to be installed

```shell
 sudo bash -c "$(curl -LSs <https://github.com/dockermgr/installer/raw/main/install.sh>)"
 dockermgr --config && dockermgr install scripts  
```

#### Automatic install/update  

```shell
dockermgr install REPLACE_APPNAME
```


#### Manual install

```shell
git clone https://github.com/dockermgr/REPLACE_APPNAME "$HOME/.local/share/CasjaysDev/dockermgr/REPLACE_APPNAME"
bash -c "$HOME/.local/share/CasjaysDev/dockermgr/REPLACE_APPNAME/install.sh"
```
  
#### Just run

mkdir -p "$HOME/.local/share/srv/docker/REPLACE_APPNAME/"

git clone <https://github.com/dockermgr/REPLACE_APPNAME> "$HOME/.local/share/CasjaysDev/dockermgr/REPLACE_APPNAME"

cp -Rf "$HOME/.local/share/srv/docker/REPLACE_APPNAME/system/*" "$HOME/.local/share/srv/docker/REPLACE_APPNAME/"

sudo docker run -d \
--name="REPLACE_APPNAME" \
--hostname "checkip" \
--restart=unless-stopped \
--privileged \
-e TZ="${TZ:-${TIMEZONE:-America/New_York}}" \
-v "$HOME/.local/share/srv/docker/REPLACE_APPNAME/data":/data:z \
-v "$HOME/.local/share/srv/docker/REPLACE_APPNAME/config":/config:z \
-p PORT:INT_PORT \
REPLACE_APPNAME/REPLACE_APPNAME 1>/dev/null


## Author  

👤 **Jason Hempstead**  
