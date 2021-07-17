#!/usr/bin/env bash

set -e

case "$1" in
  # To run the app you'd do `docker run -it <img>`
  run)
    uwsgi --ini uwsgi.ini
    ;;
  # To test the app you'd do `docker run -it <img> test`
  test)
    python3.7 -m pip install -r requirements-dev.txt \
    && black . --check
    ;;
  *)
    exec $1
esac
