rserverport=8787
GREEN='\033[0;32m'
NOCOLOR='\033[0m'
checkport=`ss -tulpn | grep ":${rserverport}"`
while [ ! -z "$checkport" ]
do
   rserverport=`echo ${rserverport} + 1 | bc`
   echo $rserverport
   checkport=`ss -tulpn | grep ":${rserverport}"`
done
export PORT=$rserverport
export HOST=`hostname`

export USER=`whoami`

echo  "\n\nThis is the Rstudio server container running R 4.1.0 from Rocker"
echo ""
echo "This is a separate R version from the rest of Hoffman2"
echo "When you install libraries from this Rstudio/R, they will be in ~/R/APPTAINER/h2-rstudio_4.1.0"
echo ""
echo  "Your Rstudio server is running on: ${GREEN} ${HOST} ${NOCOLOR}"
echo  "It is running on PORT: ${GREEN} ${PORT} ${NOCOLOR}"
echo ""
echo "Open a SSH tunnel on your local computer by running:"
echo  "${GREEN} ssh -N -L ${PORT}:${HOST}:${PORT} ${USER}@hoffman2.idre.ucla.edu ${NOCOLOR}"
echo ""
echo  "Then open your web browser to ${GREEN} http://localhost:${PORT} ${NOCOLOR}"
echo ""
echo "Please run [CTRL-C] on this process to exit Rstudio"
echo ""
rserver --www-port=${PORT}
