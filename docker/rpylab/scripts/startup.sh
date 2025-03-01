#!/bin/bash

case "$1" in
    rstudio)
        rserverport="${R_SERVER_PORT:-8787}"
        GREEN='\033[0;32m'
        NOCOLOR='\033[0m'
        checkport=$(ss -tulpn | grep ":${rserverport}")
        while [ ! -z "$checkport" ]
        do
           rserverport=$(echo ${rserverport} + 1 | bc)
           checkport=$(ss -tulpn | grep ":${rserverport}")
        done
        export PORT=$rserverport
        export HOST=$(hostname)
        export PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
        echo -e "Your Rstudio server is running on: ${GREEN} ${HOST} ${NOCOLOR}"
        echo -e "It is running on PORT: ${GREEN} ${PORT} ${NOCOLOR}"
        echo ""
        echo -e "Your Rstudio Username is: ${GREEN} ${USER} ${NOCOLOR}"
        echo -e "Your Rstudio Password is: ${GREEN} ${PASSWORD} ${NOCOLOR}"
        echo "Please run [CTRL-C] on this process to exit Rstudio"
        echo ""
        rserver --server-user=${USER} --www-port=${PORT} --auth-none=0 --auth-pam-helper-path=pam-helper
        ;;
    jupyter)
        jupyterport="${JUPYTER_SERVER_PORT:-8888}"
        jupyter lab --ip 0.0.0.0 --port $jupyterport
        ;;
    R)
        shift  # This removes the first argument and passes the rest to Rscript
        R "$@"
        ;;
    python)
        shift  # This removes the first argument and passes the rest to Python
        python "$@"
        ;;
    Rscript)
        shift  # This removes the first argument and passes the rest to Rscript
        Rscript "$@"
        ;;
    python3)
        shift  # This removes the first argument and passes the rest to Python3
        python3 "$@"
        ;;
    *)
        echo "Usage: $0 {rstudio|jupyter|R|python|Rscript|python3} args"
        ;;
esac

