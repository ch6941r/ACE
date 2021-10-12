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
	echo -e "\nUSAGE: systemStats [-t temperature] [-i ipv4 address] [-c cpu usage]"
	echo -e "\t\t  [-v version]"
	echo -e "\t\t  For more information see man systemStats"
}

# Check for arguments (error checking).
if [ $# -lt 1 ];then
	USAGE "Not enough arguments"
	exit 1
elif [ $# -gt 3 ];then
	USAGE "Too many arguments"
	exit 1
elif [[ ( $1 == '-h' ) || ( $1 == '--help' ) ]];then
	USAGE "HELP TEXT!"
	exit 1
fi

# Frequently scripts are written so that arguments can be passed in any order using 'flags'.
# With the flags method some of the arguments can be made mandatory.
# E.G. with a:b (a is mandatory and b is optional). With abc (a,b, and c, are all optional).
while getopts vitc OPTION
do
case ${OPTION}
in
c) USAGE=$(grep -w 'cpu' /proc/stat | awk '{usage=($2+$3+$4+$6+$7+$8)*100/($2+$3+$4+$5+$6+$7+$8)}
					   {free=($5)*100/($2+$3+$4+$5+$6+$7+$8)} 
					   END {printf "  Used CPU: %.2f%%",usage}
					       {printf "Free CPU: %.2f%%",free}')
	echo ${USAGE};;
i) IP=$(ifconfig wlan0 | grep -w inet | awk '{print$2}')
	echo ${IP};;
#v) echo -e "systemStats:\n\t   Version: ${VERSION} \t RELEASED: ${RELEASED} \t Author: ${AUTHOR}";;
t) TEMP=$(cat /sys/class/thermal/thermal_zone0/temp)
	echo "$((TEMP/1000)) C";;
#t) TEMP=$(cat /sys/class/thermal/thermal_zone0/temp)
esac
done

# Generate System Log
NOW=$(date +%Y-%m-%dT%H:%M:%SZ)
echo -e ${NOW} "IP: ${IP}\t\tTemp: ${TEMP}\tUsage: ${USAGE}" >> ${FILE}

# End of Script
