#!/usr/bin/env bash

case "$1" in
  run)
    python3.7 main.py
    ;;
  *)
    exec $1
esac
