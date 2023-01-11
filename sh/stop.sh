echo "#####"
echo "Stopping container"
docker stop $(docker ps -a -q --filter ancestor=$1)
