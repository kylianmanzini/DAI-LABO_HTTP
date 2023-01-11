
if [ $2 == "build" ]; then
    ./sh/build.sh $1


elif [ $2 == "start" ]; then
    ./sh/start.sh $1


elif [ $2 == "stop" ]; then
    ./sh/stop.sh $1

elif [ $2 == "build_start" ]; then
    ./sh/build.sh $1
    ./sh/start.sh $1

elif [ $1 == "dai/apache" ]; then
  if [ $2 == "get_conf" ]; then
      ./sh/get_conf.sh $1
  fi

else
  echo "unknown command. Please use me as follow :"
  echo "run.sh <relatedImage> <action>"
  echo "actions are : "
  echo " - build"
  echo " - build_start"
  echo " - stop"
  echo " * Apache-image only :"
  echo " - get_conf"
fi

echo "press any key to continue..."
read -n 1 -s