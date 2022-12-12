containerName=$(grep -o '"containerName": "[^"]*' ./sh/data.json | grep -o '[^"]*$')

if [ $1 == "build" ]; then
    ./sh/build.sh $containerName
fi

if [ $1 == "start" ]; then
    ./sh/start.sh $containerName
fi

if [ $1 == "stop" ]; then
    ./sh/stop.sh $containerName
fi 

if [ $1 == "buildstart" ]; then
    ./sh/build.sh $containerName
    ./sh/start.sh $containerName
fi

#read -s -n 1 -p "Press any key to close . . ."