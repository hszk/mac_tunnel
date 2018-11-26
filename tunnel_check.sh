function webmaster_tunnel_check() {
  local SSL_TUNNEL_LOCAL_PORT=$1
  local SSL_TUNNEL_DEST_HOST=$2
  local SSL_TUNNEL_DEST_PORT=$3
  local SSH_TUNNEL_PROXY_USER=$4
  local SSH_TUNNEL_PROXY_HOST=$5
  local SSH_TUNNEL_PROXY_PORT=$6
  local TMP_CTRL_SOCKET="tmp-ctrl.${SSL_TUNNEL_LOCAL_PORT}.${SSL_TUNNEL_DEST_HOST}.${SSL_TUNNEL_DEST_PORT}.socket"

  if [ -e "${TMP_CTRL_SOCKET}" ]; then
    echo "ssh -S ${TMP_CTRL_SOCKET} -fnNT -O check ${SSH_TUNNEL_PROXY_USER}@${SSH_TUNNEL_PROXY_HOST} -p ${SSH_TUNNEL_PROXY_PORT}"
  else
    echo "echo ${TMP_CTRL_SOCKET} not exists."
  fi
}

export TMP_LOG_FILE="tmp.$(date +'%Y%m%d%H%M%S').log"

$(tunnel_check 12201 humidai_to_upserver 12345 user humidai 12345)
$(tunnel_check 12202 humidai_to_upserver2 12345 user humidai 12345)

if [ -e "$TMP_LOG_FILE" ]; then
  cat $TMP_LOG_FILE
  rm -f $TMP_LOG_FILE
fi
