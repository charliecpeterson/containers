#!/bin/bash
if [ -f /opt/intel/oneapi/setvars.sh ]; then
  source /opt/intel/oneapi/setvars.sh --force
fi


if [ "$USE_JUPYTER" == "TRUE" ] ; then
        jupyterport="${JUPYTER_SERVER_PORT:-8888}"
	jupyter lab --ip 0.0.0.0 --port $jupyterport
elif [ "$USE_PYTHON" == "TRUE" ] ; then
	python "$@"
else
        jupyterport="${JUPYTER_SERVER_PORT:-8888}"
        jupyter lab --ip 0.0.0.0 --port $jupyterport
fi

