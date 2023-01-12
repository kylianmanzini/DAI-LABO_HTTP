echo "#####"
echo "Exec bash in image"
echo $(docker ps -a -q --filter ancestor=$1)
docker exec -i $(docker ps -a -q --filter ancestor=$1) bash -c " cd .. && cd .. && cd .. && cd etc/apache2 && cat apache2.conf"