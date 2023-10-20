#!/bin/sh

BASE_DIR="$(readlink -f "$(dirname "${BASH_SOURCE[0]}")/../../")"

CRIU="${BASE_DIR}/criu/criu"
criu=$CRIU
if [ $(which python3) ]; then
	PYTHON=python3
elif [ $(which python2) ]; then
	PYTHON=python2
else
	echo "FAIL: Neither python3 nor python2"
	exit 1
fi
#export PYTHON
export PYTHONPATH="${BASE_DIR}/lib:${BASE_DIR}/crit:${PYTHONPATH-}"
CRIT="python3 -m crit"
crit=$CRIT

CRIU_COREDUMP="${BASE_DIR}/coredump/coredump"
criu_coredump=$CRIU_COREDUMP
