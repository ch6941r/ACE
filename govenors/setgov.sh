#! /usr/bin/env bash created by: Chris Halsall Date Created: 26/10/2021 Version: 0.1

GOVDIR="/sys/devices/system/cpu/cpu*/cpufreq/scaling_governor"
AVAILGOVS=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors)

while [[ 1 ]]; do
	echo "Please select from the following governors:"
	
	for i in "${AVAILGOVS[@]}" 
	do
		echo -e "${i}\n"
	done

	read GOV
	# use grep to match input with sub string of AVAILGOVS
	if grep -q "$GOV" <<< "${AVAILGOVS}\n"; then
		break
	fi
done

echo -n "Changing the scaling_governor for CPU 0 1 2 3 to "

echo "${GOV}" | sudo tee ${GOVDIR}
echo "Success your new Scaling Governor is ${GOV}"
