#! /usr/bin/env bash

#created by: Chris Halsall
#date created: 2021-11-02

#This is a template of a bash daemon. To use for yourself, just set the
#DAEMONNAME variable and then enter in the commans to run in the doCommands
#function. Modify the variables just below to fit your preference.

DAEMONNAME="MY-DAEMON"

# $$ is the process IS (PID) of then script itself
MYPID=$$
# gets the directory path for the script
PIDDIR="$(dirname "${BASH_SOURCE[0]}")"
PIDFILE="${PIDDIR}/${DAEMONNAME}.pid"
echo ${PIDFILE}

LOGDIR="$(dirname "${BASH_SOURCE[0]}")"

#To use a dated log file.
#LOGFILE="${LOGDIR}/$DAEMONNAME}-$(date +"%Y-%m-%dT%H:%M:%SZ").log"
#To use a regular log file.
LOGFILE="${LOGDIR}/${DAEMONNAME}.log"

#Log maxsize in KB
LOGMAXSIZE=1024 #1MB

RUNINTERVAL=60 #secs

doCommands() {
  #This is where you put all the commands for the daemon.
  echo "Running commands..."
  log '*** '$(date +"%Y-%m-%dT%H:%M:%SZ")": and important message or log detail..."
}

###################################################################################
#Below is the template functionality of the Daemon
###################################################################################

setupDaemon() {
  #Make sure the directories work.
  if [[ ! -d "${PIDDIR}" ]]; then
    mkdir "${PIDDIR}"
  fi

  if [[ ! -d "${LOGDIR}" ]]; then
    mkdir "${LOGDIR}"
  fi

  if [[ ! -f "${LOGFILE}" ]]; then
    touch "${LOGFILE}"
  else
    #check to see if we need to rotate the logs.
    size=$(( $(stat --printf="%s" "${LOGFILE}") / 1024 ))

    if [[ $size -gt ${LOGMAXSIZE} ]]; then
      mv ${LOGFILE} "${LOGFILE}.$(date +%Y-%m-%dT%H:%M:%SZ).old"
      touch "${LOGFILE}"
    fi
  fi
}

startDaemon() {
  setupDaemon
  if ! checkDaemon; then
    echo 1>&2 "Error: ${DAEMONNAME} is already running."
    log '*** '$(date +"%Y-%m-%dT%H:%M:%SZ")": $USER already running ${DAEMONNAME} PID: "$(cat ${PIDFILE})
    exit 1
  fi

  echo " * Starting ${DAEMONNAME} with PID: ${MYPID}."
  echo "${MYPID}" > "${PIDFILE}"

  log '*** '$(date +"%Y-%m-%dT%H:%M:%SZ")": $USER Starting up ${DAEMONNAME} PID: ${MYPID}."

  loop
}

stopDaemon() {
  if checkDaemon; then
    echo 1>&2 " * Error: ${DAEMONNAME} is not running."
    exit 1
  fi

  echo " * Stopping ${DAEMONNAME}"

  if [[ ! -z $(cat "${PIDFILE}") ]]; then
    kill -9 $(cat "${PIDFILE}") &> /dev/null
    log '*** '$(date +"%Y-%m-%dT%H:%M:%SZ")"${DAEMONNAME} stopped}."
  else
    echo 1>&2 "Cannot find PID of running daemon"
  fi
}

statusDaemon() {
  if ! checkDaemon; then
    echo " * ${DAEMONNAME} is running."
    log '*** '$(date +"%Y-%m-%dT%H:%M:%SZ")": ${DAEMONNAME} $USER checked status - Running with PID: ${MYPID}."
  else
    echo " * ${DAEMONNAME} is running."
    log '*** '$(date +"%Y-%m-%dT%H:%M:%SZ")": ${DAEMONNAME} $USER checked status - Not Running."
  fi
  exit 0
}

restartDaemon() {
  if checkDaemon; then
    echo "${DAEMONNAME} isn't running."
    log '*** '$(date +"%Y-%m-%dT%H:%M:%SZ")": ${DAEMONNAME} $USER restarted"
    exit 1
  fi
  stopDaemon
  startDaemon
}

checkDaemon() {
  if [[ -z "${OLDPID}" ]]; then
    return 0
  elif ps -ef | grep "${OLDPID}" | grep -v grep &> /dev/null ; then
    if [[ "${PIDFILE}" && $(cat "${PIDFILE}") -eq ${OLDFILE} ]]; then
      #Daemon is running.
      return 1
    else
      #Daemon isn't running.
      return 0
    fi
  elif ps -ef | grep "${DAEMONNAME}" | grep -v grep | grep -v "${MYPID}" | grep -v "0:00.00" | grep bash &> /dev/null ; then
    #Daemon is running but eithout the correct PID. Restart it.
    log '*** '$(date +"%Y-%m-%dT%H:%M:%SZ")": ${DAEMONNAME} running with invalid PID: restarting."
    restartDaemon
    return 1
  else
    #Daemon is not running.
    return 0
  fi
  return 1
}

loop() {
  while true; do
    doCommands
    sleep 60
  done
}

log() {
  #Generic log  function.
  echo "$1" >> "${LOGFILE}"
}

########################################################################################################
#Parse the Command
########################################################################################################

if [[ -f "${PIDFILE}" ]]; then
  OLDPID=$(cat "${PIDFILE}")
fi

checkDaemon

case "$1" in
  start)
    startDaemon
    ;;
  stop)
    stopDaemon
    ;;
  status)
    statusDaemon
    ;;
  restart)
    restartDaemon
    ;;
  *)
  echo 1>&2 " * Error : usage $0 { start | stop | restart | status }"
  exit 1
esac

#close program as intended
exit 0


