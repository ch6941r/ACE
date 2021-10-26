# CREATED BY: Chris Halsall
# DATE CREATED: 05/10/2021
# VERSION: V0.2

# This script is designed to gather system statistics.
AUTHOR="C.Halsall"
VERSION="V0.3"
RELEASED="2021-10-05"
FILE=~/ACE/systemstats.log

# Display help message.
USAGE(){
	echo -e $1
	echo -e "\t\t  [-v version]"
	echo -e "\t\t  For more information see man systemStats"
}

# Check for arguments (error checking).
if [ $# -gt 1 ];then
	USAGE "Not enough arguments"
	exit 1
elif [ $# == '-v' ];then
	echo -e "systemStats:\n\t  Version: ${VERSION} Released: ${RELEASED} Author: ${AUTHOR}"
	exit 1
elif [[ ( $1 == '-h' ) || ( $1 == '--help' ) ]];then
	USAGE "HELP TEXT!"
	exit 1
fi

USAGE=$(grep -w 'cpu' /proc/stat | awk '{usage=($2+$3+$4+$6+$7+$8)*100/($2+$3+$4+$5+$6+$7+$8)}
					   {free=($5)*100/($2+$3+$4+$5+$6+$7+$8)} 
					   END {printf "  Used CPU: %.2f%%",usage}
					       {printf "Free CPU: %.2f%%",free}')
IP=$(ifconfig wlan0 | grep -w inet | awk '{print$2}')
TEMP=$(cat /sys/class/thermal/thermal_zone0/temp)

# Generate System Log
NOW=$(date +%Y-%m-%dT%H:%M:%SZ)
echo -e ${NOW} "IP: ${IP}\t\tTemp: ${TEMP}\tUsage: ${USAGE}" >> ${FILE}

# End of Script
