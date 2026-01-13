#!/bin/bash

case "$1" in
  jupyter)
    exec jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root
    ;;
  run)
    exec python polygraphs/run.py "${@:2}"
    ;;
  *)
    exec "$@"
    ;;
esac
