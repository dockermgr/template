#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 202108290932-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.com
# @License       : WTFPL
# @ReadME        : REPLACE_APPNAME --help
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, Casjays Developments
# @Created       : Sunday, Aug 29, 2021 09:32 EDT
# @File          : REPLACE_APPNAME
# @Description   :
# @TODO          :
# @Other         :
# @Resource      :
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="$(basename "$0")"
VERSION="202108290932-git"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
SRC_DIR="${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set bash options
if [[ "$1" == "--debug" ]]; then shift 1 && set -xo pipefail && export SCRIPT_OPTS="--debug" && export _DEBUG="on"; fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Import functions
CASJAYSDEVDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}"
SCRIPTSFUNCTDIR="${CASJAYSDEVDIR:-/usr/local/share/CasjaysDev/scripts}/functions"
SCRIPTSFUNCTFILE="${SCRIPTSAPPFUNCTFILE:-app-installer.bash}"
SCRIPTSFUNCTURL="${SCRIPTSAPPFUNCTURL:-https://github.com/dfmgr/installer/raw/main/functions}"
connect_test() { ping -c1 1.1.1.1 &>/dev/null || curl --disable -LSs --connect-timeout 3 --retry 0 --max-time 1 1.1.1.1 2>/dev/null | grep -e "HTTP/[0123456789]" | grep -q "200" -n1 &>/dev/null; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if [ -f "$PWD/$SCRIPTSFUNCTFILE" ]; then
  . "$PWD/$SCRIPTSFUNCTFILE"
elif [ -f "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" ]; then
  . "$SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE"
elif connect_test; then
  curl -LSs "$SCRIPTSFUNCTURL/$SCRIPTSFUNCTFILE" -o "/tmp/$SCRIPTSFUNCTFILE" || exit 1
  . "/tmp/$SCRIPTSFUNCTFILE"
else
  echo "Can not load the functions file: $SCRIPTSFUNCTDIR/$SCRIPTSFUNCTFILE" 1>&2
  exit 1
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Call the main function
user_installdirs
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Define extra functions
__sudo() { if sudo -n true; then eval sudo "$*"; else eval "$*"; fi; }
__sudo_root() { sudo -n true && ask_for_password true && eval sudo "$*" || return 1; }
__enable_ssl() { [[ "$SERVER_SSL" = "yes" ]] && [[ "$SERVER_SSL" = "true" ]] && return 0 || return 1; }
__ssl_certs() { [ -f "${1:-$SERVER_SSL_CRT}" ] && [ -f "${2:-SERVER_SSL_KEY}" ] && return 0 || return 1; }
__port_not_in_use() { [[ -d "/etc/nginx/vhosts.d" ]] && grep -Rsq "${1:-$SERVER_PORT}" /etc/nginx/vhosts.d && return 0 || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Make sure the scripts repo is installed
scripts_check
REPO_BRANCH="${GIT_REPO_BRANCH:-master}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Defaults
APPNAME="REPLACE_APPNAME"
APPDIR="$HOME/.local/share/docker/REPLACE_APPNAME"
DATADIR="$HOME/.local/share/docker/REPLACE_APPNAME/files"
INSTDIR="$HOME/.local/share/dockermgr/docker/REPLACE_APPNAME"
REPO="${DOCKERMGRREPO:-https://github.com/dockermgr}/REPLACE_APPNAME"
REPORAW="$REPO/raw/$REPO_BRANCH"
APPVERSION="$(__appversion "$REPORAW/version.txt")"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup plugins
HUB_URL="template/template"
SERVER_HOST="${APPNAME:-$(hostname -f 2>/dev/null)}"
SERVER_PORT="${SERVER_PORT:-14000}"
SERVER_PORT_INT="${SERVER_PORT_INT:-80}"
SERVER_PORT_SSL="${SERVER_PORT_SSL:-15000}"
SERVER_PORT_SSL_INT="${SERVER_PORT_SSL_INT:-443}"
SERVER_PORT_ADMIN="${SERVER_PORT_SSL:-16000}"
SERVER_PORT_ADMIN_INT="${SERVER_PORT_SSL_INT:-8080}"
SERVER_TIMEZONE="${TZ:-${TIMEZONE:-America/New_York}}"
SERVER_SSL_CRT="/etc/ssl/CA/CasjaysDev/certs/localhost.crt"
SERVER_SSL_KEY="/etc/ssl/CA/CasjaysDev/private/localhost.key"
[[ -f "$SERVER_SSL_CRT" ]] && [[ -f "$SERVER_SSL_KEY" ]] && SERVER_SSL="true"
[[ -n "$SERVER_SSL" ]] || SERVER_SSL="${SERVER_SSL:-false}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Require a version higher than
dockermgr_req_version "$APPVERSION"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Call the dockermgr function
dockermgr_install
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Script options IE: --help
show_optvars "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Requires root - no point in continuing
#sudoreq "$0 $*" # sudo required
#sudorun # sudo optional
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Do not update - add --force to overwrite
#installer_noupdate "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# initialize the installer
dockermgr_run_init
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ensure directories exist
ensure_dirs
ensure_perms
__sudo mkdir -p "$DATADIR/data"
__sudo mkdir -p "$DATADIR/config"
__sudo chmod -Rf 777 "$APPDIR"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Clone/update the repo
if am_i_online; then
  if [ -d "$INSTDIR/.git" ]; then
    message="Updating $APPNAME configurations"
    execute "git_update $INSTDIR" "$message"
  else
    message="Installing $APPNAME configurations"
    execute "git_clone $REPO $INSTDIR" "$message"
  fi
  # exit on fail
  failexitcode $? "$message has failed"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Copy over data files - keep the same stucture as -v dataDir/mnt:/mount
[[ -d "$INSTDIR/dataDir" ]] && cp -Rf "$INSTDIR/dataDir/*" "$DATADIR/"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Main progam
if [ -f "$INSTDIR/docker-compose.yml" ] && cmd_exists docker-compose; then
  printf_blue "Installing containers using docker compose"
  sed -i "s|REPLACE_DATADIR|$DATADIR" "$INSTDIR/docker-compose.yml"
  if cd "$INSTDIR"; then
    __sudo docker-compose pull &>/dev/null
    __sudo docker-compose up -d &>/dev/null
  fi
else
  if docker ps -a | grep -qsw "$APPNAME"; then
    __sudo docker stop "$APPNAME" &>/dev/null
    __sudo docker rm -f "$APPNAME" &>/dev/null
  fi
  if __enable_ssl && __ssl_certs "$SERVER_SSL_CRT" "$SERVER_SSL_KEY"; then
    ## SSL
    __sudo docker run -d \
      --name="$APPNAME" \
      --hostname "$SERVER_HOST" \
      --restart=unless-stopped \
      --privileged \
      -e TZ="$SERVER_TIMEZONE" \
      -v "$DATADIR/data":/data:z \
      -v "$DATADIR/config":config:z \
      -p $SERVER_PORT:$SERVER_PORT_INT \
      -p $SERVER_PORT_SSL:$SERVER_PORT_SSL_INT \
      "$HUB_URL" 1>/dev/null
  else
    __sudo docker run -d \
      --name="$APPNAME" \
      --hostname "$SERVER_HOST" \
      --restart=unless-stopped \
      --privileged \
      -e TZ="$SERVER_TIMEZONE" \
      -v "$DATADIR/data":/data:z \
      -v "$DATADIR/config":config:z \
      -p $SERVER_PORT:$SERVER_PORT_INT \
      "$HUB_URL" 1>/dev/null
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Install nginx proxy
if [[ ! -f "/etc/nginx/vhosts.d/$APPNAME.conf" ]] && [[ -f "$APPDIR/nginx/proxy.conf" ]]; then
  if __port_not_in_use "$SERVER_PORT"; then
    __sudo_root cp -Rf "$APPDIR/nginx/proxy.conf" "/etc/nginx/vhosts.d/$APPNAME.conf"
    sed -i "s|REPLACE_APPNAME|$APPNAME|g" "/etc/nginx/vhosts.d/$APPNAME.conf"
    sed -i "s|REPLACE_SERVER_HOST|$SERVER_HOST|g" "/etc/nginx/vhosts.d/$APPNAME.conf"
    sed -i "s|REPLACE_SERVER_PORT|$SERVER_PORT|g" "/etc/nginx/vhosts.d/$APPNAME.conf"
    __sudo_root systemctl reload nginx
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# run post install scripts
run_postinst() {
  dockermgr_run_post
  if ! grep -sq "$SERVER_HOST" /etc/hosts; then
    if [[ -n "$SERVER_PORT_INT" ]]; then
      if [[ $(hostname -d 2>/dev/null | grep '^') = 'local' ]]; then
        echo "$SERVER_LISTEN     $APPNAME.local" | sudo tee -a /etc/hosts &>/dev/null
      else
        echo "$SERVER_LISTEN     $APPNAME.local" | sudo tee -a /etc/hosts &>/dev/null
        echo "$SERVER_LISTEN     $SERVER_HOST" | sudo tee -a /etc/hosts &>/dev/null
      fi
    fi
  fi
}
#
execute "run_postinst" "Running post install scripts"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# create version file
dockermgr_install_version
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# run exit function
if docker ps -a | grep -qs "$APPNAME"; then
  printf_blue "DATADIR in $DATADIR"
  printf_cyan "Installed to $INSTDIR"
  [[ -n "$SERVER_PORT" ]] && printf_blue "Service is running on: $SERVER_IP:$SERVER_PORT"
  [[ -n "$SERVER_PORT" ]] && printf_blue "and should be available at: http://$SERVER_LISTEN:$SERVER_PORT or http://$SERVER_HOST:$SERVER_PORT"
  [[ -z "$SERVER_PORT" ]] && printf_yellow "This container does not have a web interface"
else
  printf_error "Something seems to have gone wrong with the install"
fi
run_exit &>/dev/null
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# lets exit with code
exit ${exitCode:-$?}
