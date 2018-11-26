#!/bin/bash

function tunnel_close() {
  local SSL_TUNNEL_LOCAL_PORT=$1
  local SSL_TUNNEL_DEST_HOST=$2
  local SSL_TUNNEL_DEST_PORT=$3
  local SSH_TUNNEL_PROXY_USER=$4
  local SSH_TUNNEL_PROXY_HOST=$5
  local SSH_TUNNEL_PROXY_PORT=$6
  local TMP_CTRL_SOCKET="tmp-ctrl.${SSL_TUNNEL_LOCAL_PORT}.${SSL_TUNNEL_DEST_HOST}.${SSL_TUNNEL_DEST_PORT}.socket"

  if [ -e "${TMP_CTRL_SOCKET}" ]; then
    ssh -S ${TMP_CTRL_SOCKET} -fnNT \
      -O exit \
      ${SSH_TUNNEL_PROXY_USER}@${SSH_TUNNEL_PROXY_HOST} -p ${SSH_TUNNEL_PROXY_PORT} \
      2>&1 >> $TMP_LOG_FILE
  fi
  if [ -e "${TMP_CTRL_SOCKET}" ]; then
    rm -f "${TMP_CTRL_SOCKET}"
  fi
}

export TMP_LOG_FILE="tmp.$(date +'%Y%m%d%H%M%S').log"

tunnel_close 12201 humidai_to_upserver 12345 user humidai 12345 > /dev/null
tunnel_close 12201 humidai_to_upserver2 12345 user humidai 12345 > /dev/null

if [ -e "$TMP_LOG_FILE" ]; then
  cat $TMP_LOG_FILE
  rm -f $TMP_LOG_FILE
fi

netstat -nat | grep LISTEN
