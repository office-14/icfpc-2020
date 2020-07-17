#!/bin/sh

ruby app/main.rb "$@" || echo "run error code: $?"
