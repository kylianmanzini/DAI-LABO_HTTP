echo "#####"
echo "Starting container"

if [ $1 == "dai/apache" ]; then
  docker run -p 9000:80 -t "dai/apache"  $1
elif [ $1 == "dai/api" ]; then
  docker run -p 9001:3000 -t "dai/api" $1
else
  echo "image is not correct"
fi
