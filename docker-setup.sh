#!/bin/bash

# 1. Create volume
docker volume create my_volume

# 2. Run first container with volume
docker run -d --name volume_container -v my_volume:/app_data nginx

# 3. Store test data inside container
docker exec -it volume_container bash -c "echo 'Docker volume persistence test' > /app_data/data.txt"

# 4. Remove first container
docker rm -f volume_container

# 5. Recreate container with same volume
docker run -d --name new_container -v my_volume:/app_data nginx
docker exec -it new_container cat /app_data/data.txt

# 6. Create custom network
docker network create my_network

# 7. Run containers on the network
docker run -d --name web --network my_network nginx
docker run -d --name app --network my_network alpine sleep 1000

# 8. Network alias example
docker run -d --name db --network my_network --network-alias database mysql

# 9. Test communication
docker exec -it app ping -c 3 web
docker exec -it app ping -c 3 database

# 10. Inspect resources
docker volume inspect my_volume
docker network inspect my_network

echo "Setup complete!"
