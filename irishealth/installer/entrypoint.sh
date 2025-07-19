#!/bin/bash
set -e

# Run IRIS process
iris start IRIS

# Run IRIS-session
iris session IRIS < /opt/irisapp/installer/iris.script

tail -f /dev/null