#!/bin/bash

single_arg() {
	! [ $# -eq 1 ] && \
	echo "Usage: $0 argument" &&\
	exit 1 \
	|| echo $1; \
}

