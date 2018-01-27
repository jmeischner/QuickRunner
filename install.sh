#!/usr/bin/env bash

BASEDIR=$(basename $(pwd))

if [ "$BASEDIR" == "QuickRunner" ]
then
  swift build -c release >/dev/null 2>&1
  cp ./.build/release/QuickRunner /usr/local/bin
  echo "QuickRunner was successfully installed."
else
  echo "You have to execute this script in the QuickRunner directory."
fi