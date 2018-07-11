#!/bin/sh
set -e

if [[ $(echo "$1" | cut -c1) = "-" ]]; then
  echo "$0: assuming arguments for dogecoind"

  set -- dogecoind "$@"
fi

if [[ $(echo "$1" | cut -c1) = "-" ]] || [[ "$1" = "dogecoind" ]]; then
  mkdir -p "$BITCOIN_DATA"
  chmod 700 "$BITCOIN_DATA"

  echo "$0: setting data directory to $BITCOIN_DATA"

  set -- "$@" -datadir="$BITCOIN_DATA"
fi

if [[ "$1" = "dogecoind" ]] || [[ "$1" = "dogecoin-cli" ]] || [[ "$1" = "dogecoin-tx" ]]; then
  echo
  exec "$@"
fi

echo
exec "$@"
