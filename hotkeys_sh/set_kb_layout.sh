LAYOUT=us

for item in "us", "dvorak"; do
	if [ $1 = $item ]; then
		LAYOUT=$1
	fi
done

CMD="setxkbmap -layout"
NOTIFY_TEXT=""

if [ "$LAYOUT" = "dvorak" ]; then
	CMD="$CMD us -variant dvp"
	NOTIFY_TEXT="Dvorak"
fi

if [ "$LAYOUT" = "us" ]; then
	CMD="$CMD $LAYOUT"
	NOTIFY_TEXT="US"
fi

$CMD
notify-send "Changed keyboard layout to :" $NOTIFY_TEXT -t 250
