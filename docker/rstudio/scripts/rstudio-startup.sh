#!/bin/bash
if [ -f /opt/intel/oneapi/setvars.sh ]; then
  source /opt/intel/oneapi/setvars.sh --force
fi


if [ "$USE_JUPYTER" == "TRUE" ] ; then
        jupyterport="${JUPYTER_SERVER_PORT:-8888}"
	jupyter lab --ip 0.0.0.0 --port $jupyterport
elif [ "$USE_PYTHON" == "TRUE" ] ; then
	python "$@"
elif [ "$USE_R" == "TRUE" ] ; then
	Rscript "$@"
else

rserverport="${R_SERVER_PORT:-8787}"
GREEN='\033[0;32m'
NOCOLOR='\033[0m'
checkport=`ss -tulpn | grep ":${rserverport}"`
while [ ! -z "$checkport" ]
do
   rserverport=`echo ${rserverport} + 1 | bc`
   checkport=`ss -tulpn | grep ":${rserverport}"`
done
export PORT=$rserverport
export HOST=$(hostname)

export PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)

echo  -e "Your Rstudio server is running on: ${GREEN} ${HOST} ${NOCOLOR}"
echo  -e "It is running on PORT: ${GREEN} ${PORT} ${NOCOLOR}"
echo ""
echo -e "Your Rstudio Username is: ${GREEN} ${USER} ${NOCOLOR}"
echo -e "Your Rstudio Password is: ${GREEN} ${PASSWORD} ${NOCOLOR}"
echo "Please run [CTRL-C] on this process to exit Rstudio"
echo ""

rserver --server-user=${USER} --www-port=${PORT} --auth-none=0 --auth-pam-helper-path=pam-helper

fi

