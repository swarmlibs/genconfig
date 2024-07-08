#!/bin/bash
# Copyright (c) Swarm Library Maintainers.
# SPDX-License-Identifier: MIT
set -e
export GOMPLATE_LOG_FORMAT=${GOMPLATE_LOG_FORMAT:-logfmt}

# Run command with gomplate if the first argument contains a "-" or is not a system command. The last
# part inside the "{}" is a workaround for the following bug in ash/dash:
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=874264
if [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ] || { [ -f "${1}" ] && ! [ -x "${1}" ]; }; then
  gomplate "$@" # Run gomplate with the arguments
  while true; do sleep 5; done # Do nothing and wait for the SIGTERM
else
  exec "$@"
fi
