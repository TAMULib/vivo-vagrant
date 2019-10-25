#!/bin/sh

lsof -i:9000 -sTCP:LISTEN | awk 'NR > 1 {print $2}' | xargs kill -15