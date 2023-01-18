echo "#####"
echo "Building image"
echo $1
if [ $1 == "dai/apache" ]; then
  docker build -t $1 -f "apache-image/Dockerfile" "apache-image/"
elif [ $1 == "dai/api" ]; then
  docker build -t $1 -f "express-image/Dockerfile" "express-image/"
else
  echo "image is not correct"
fi

