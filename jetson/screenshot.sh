#!/bin/bash
# Desktop screen capture
# Usage:
#   from console login:
#     ./screenshot.sh
#   from remote login:
#     ssh -CY user@xxx.xxx.xxx.xxx
#     ./screenshot.sh
# Requirement:
#   sudo apt-get -y install imagemagick

file_exists=false
array=($(ls screenshot*.png 2>/dev/null))

for filename in "${array[@]}"
do
  if [[ ${filename} =~ ^screenshot([0-9]+).png$ ]]; then
      file_exists=true
      break
  fi
done
if [ "$file_exists" = false ]; then
    FILE=screenshot0.png
    echo $FILE
    DISPLAY=:0 import -window root $FILE
else
    FILE=`(export MATCH=screenshot; \ls $MATCH*.png | sed -e "s/$MATCH/X/g" | sort -t X -k 2 -n | sed -e "s/X/$MATCH/g" | tail -n 1 | sed -r 's/^('"$MATCH"')([0-9]+)(.png)$/echo "\1$((\2+1))\3"/ge')`
    echo $FILE
    DISPLAY=:0 import -window root $FILE
fi

