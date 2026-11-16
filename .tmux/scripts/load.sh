#!/bin/sh
uptime | sed 's/.*load averages*: //' | awk '{gsub(/,/, ""); print $1}'
