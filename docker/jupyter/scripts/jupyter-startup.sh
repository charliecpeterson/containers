#!/bin/bash

if [ "$USE_PYTHON" == "TRUE" ] ; then
	python "$@"
else
        jupyterport="${JUPYTER_SERVER_PORT:-8888}"
        jupyter lab --ip 0.0.0.0 --port $jupyterport
fi

