#!/usr/bin/env bash
# $XDG_CONFIG_HOME/waybar/scripts/recording.sh

pidf="$HOME/Videos/Screencasts/process.pid"
WF_RECORDER_OPTS=""
VIDEOEXT="mkv"

if [ "$1" == "status" ];
then
	if [ -f "$pidf" ];
	then
		awk 'BEGIN{printf "{\"text\":\"\", \"tooltip\":\"Recording\\n"}
		NR==1{printf "PID: %s\\n", $0}
		NR==2{printf "Save to: %s\\n", $0}
		NR==3{printf "Log to: %s\"}", $0}' "$pidf"
	else
		echo '{"text":"", "tooltip":"Stopped"}'
	fi
	exit
elif [ "$1" == "toggle" ];
then
	if [ -f "$pidf" ];
	then
		pid=$(cat "$pidf")
		kill -2 "$pid"
		rm "$pidf"
	else
		mkdir -p "$HOME/Videos/Screencasts"
		bf="$HOME/Videos/Screencasts/$(date +'%Y%m%dT%H%M%S')"
		vidf="$bf.$VIDEOEXT"
		logf="$bf.log"
		if [ "$2" == "fullscreen" ]; then
			wf-recorder $WF_RECORDER_OPTS -f "$vidf" 1>"$logf" 2>&1 &
		elif [ "$2" == "region" ]; then
			sleep 1
			wf-recorder $WF_RECORDER_OPTS -g "$(slurp)" -f "$vidf" 1>"$logf" 2>&1 &
		else
			printf "Argument %s not valid" "$2"
			exit
		fi
		pid=$(jobs -p | tail -n 1)
		printf "%d\n%s\n%s" "$pid" "$vidf" "$logf" > "$pidf"
		disown "$pid"
	fi
	exit
else
	printf "Argument %s not valid" "$1"
fi
