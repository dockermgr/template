# Repository variables
REPO="${DOCKERMGRREPO:-https://github.com/dockermgr}/template-file"
APPVERSION="$(__appversion "$REPO/raw/${GIT_REPO_BRANCH:-main}/version.txt")"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Defaults variables
APPNAME="template-file"
INSTDIR="$HOME/.local/share/dockermgr/template-file"
APPDIR="$HOME/.local/share/srv/docker/template-file"
DATADIR="$HOME/.local/share/srv/docker/template-file/files"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Directory variables for container
SERVER_SSL_DIR="$DATADIR/ssl"
SERVER_DATA_DIR="$DATADIR/data"
SERVER_CONFIG_DIR="$DATADIR/config"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Override container variables
LOCAL_SSL_DIR="${LOCAL_SSL_DIR:-$SERVER_SSL_DIR}"
LOCAL_DATA_DIR="${LOCAL_DATA_DIR:-$SERVER_DATA_DIR}"
LOCAL_CONFIG_DIR="${LOCAL_CONFIG_DIR:-$SERVER_CONFIG_DIR}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# SSL Setup
SERVER_SSL_DIR="${SERVER_SSL_DIR:-/etc/ssl/CA/CasjaysDev}"
SERVER_SSL_CA="${SERVER_SSL_CA:-$SERVER_SSL_DIR/certs/ca.crt}"
SERVER_SSL_CRT="${SERVER_SSL_CRT:-$SERVER_SSL_DIR/certs/localhost.crt}"
SERVER_SSL_KEY="${SERVER_SSL_KEY:-$SERVER_SSL_DIR/private/localhost.key}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup variables
SERVER_IP="${CURRIP4:-127.0.0.1}"
SERVER_LISTEN="${SERVER_LISTEN:-$SERVER_IP}"
SERVER_DOMAIN="${SERVER_DOMAIN:-"$(hostname -d 2>/dev/null | grep '^' || echo local)"}"
SERVER_HOST="${SERVER_HOST:-$APPNAME.$SERVER_DOMAIN}"
SERVER_TIMEZONE="${TZ:-${TIMEZONE:-America/New_York}}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup nginx proxy variables
NGINX_HTTP="${NGINX_HTTP:-80}"
NGINX_HTTPS="${NGINX_HTTPS:-443}"
NGINX_PORT="${NGINX_HTTPS:-$NGINX_HTTP}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Port Setup [ _INT is container port ]
SERVER_PORT="${SERVER_PORT:-}"
SERVER_PORT_INT="${SERVER_PORT_INT:-}"
SERVER_PORT_ADMIN="${SERVER_PORT_ADMIN:-}"
SERVER_PORT_ADMIN_INT="${SERVER_PORT_ADMIN_INT:-}"
SERVER_PORT_OTHER="${SERVER_PORT_OTHER:-}"
SERVER_PORT_OTHER_INT="${SERVER_PORT_OTHER_INT:-}"
SERVER_WEB_PORT="${SERVER_WEB_PORT:-$SERVER_PORT}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Show user info message
SERVER_MESSAGE_USER=""
SERVER_MESSAGE_PASS=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Show post install message
SERVER_MESSAGE_POST=""
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# URL to container image [docker pull URL]
HUB_URL="hello-world"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
