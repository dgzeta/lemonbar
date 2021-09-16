#!/usr/bin/bash

Clock(){
	TIME=$(date "+%H:%M:%S")
	echo -e -n " \uf017 ${TIME}" 
}

Cal() {
    DATE=$(date "+%a, %m %B %Y")
    echo -e -n "\uf073 ${DATE}"
}

ActiveWorkspace(){
    WS_N=$(xdotool get_desktop)
    ((WS_N=WS_N+1))
    WS_TOTAL=$(xdotool get_num_desktops)
    echo -n "[ $WS_N / $WS_TOTAL ]"
}

ActiveWindow(){
	len=$(echo -n "$(xdotool getwindowfocus getwindowname)" | wc -m)
	max_len=70
	if [ "$len" -gt "$max_len" ];then
		echo -n "$(xdotool getwindowfocus getwindowname | cut -c 1-$max_len)..."
	else
		echo -n "$(xdotool getwindowfocus getwindowname)"
	fi
}

Sound(){
    SINK=$(pactl get-default-sink)
    NOTMUTED=$(pactl get-sink-mute $SINK)
    if [ $(echo $SINK | cut -d '.' -f 1) == 'bluez_sink' ] 
    then
        SYMBOL="\uf58f"
    else
        SYMBOL="\uf028"
    fi
	if [[ ! -z $NOTMUTED ]] ; then
		VOL=$(pactl get-sink-volume $SINK | awk '{print $5}' | tr -d '%\n')
		if [ $VOL -ge 85 ] ; then
			echo -e $SYMBOL " ${VOL}%"
		elif [ $VOL -ge 50 ] ; then
			echo -e $SYMBOL " ${VOL}%"
		else
			echo -e $SYMBOL " ${VOL}%"
		fi
	else
		echo -e "\uf58f M"
	fi
}

# List of all the monitors/screens you have in your setup
Monitors=$(xrandr | grep -o "^.* connected" | sed "s/ connected//")

while true; do
    opstr="%{l}$(ActiveWorkspace) %{c}$(ActiveWindow) %{r}$(Sound)  $(Clock)  $(Cal)"
    tmp=0                                                                       
    barout=""
    for m in $(echo "$Monitors"); do                                        
        barout+="%{S${tmp}}$opstr"        
        let tmp=$tmp+1                                                          
    done
    echo $barout
	sleep 0.1s
done

