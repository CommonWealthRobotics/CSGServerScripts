if [ $# -eq 0 ]; then
    echo "No tag provided"
    exit 1
elif [ $# -eq 1 ]; then
    echo "One parameter provided: $1"
fi
# Check if logged into DockerHub
if ! docker info 2>/dev/null | grep -q "Username:"; then
    echo "Error: Not logged into DockerHub"
    echo "Please run: docker login"
    exit 1
fi
docker builder prune -a
docker build -t my-local-app .
docker tag my-local-app madhephaestus/csg-server-app:$1
docker tag my-local-app madhephaestus/csg-server-app:latest
docker push madhephaestus/csg-server-app:latest
docker push madhephaestus/csg-server-app:$1
