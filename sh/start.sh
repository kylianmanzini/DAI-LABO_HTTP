echo "#####"
echo "Starting container"

if [ $1 == "dai/apache" ]; then
  docker run -p 9000:80 "dai/apache"
elif [ $1 == "dai/api" ]; then
  docker run -p 9001:3000 "dai/api"
else
  echo "image is not correct"
fi
