# Docker Volumes & Networking

## Overview
Demonstrates how Docker volumes allow data to persist beyond container lifetimes and how custom Docker networks enable container-to-container communication using names and aliases.

---

## Steps Performed

1. **Created Docker Volume**
   - Volume name: `my_volume`
   - Purpose: Persist container data even after container removal.

2. **Mounted Volume to First Container**
   - Ran a container with `my_volume` attached: `volume_container`
   - Created a file inside the container to test persistence.

3. **Verified Data Persistence**
   - Removed `volume_container`.
   - Ran a new container `new_container` with the same volume.
   - Verified the file created earlier still exists.

4. **Created Custom Network**
   - Network name: `my_network`
   - Purpose: Enable communication between containers.

5. **Connected Containers Using Network and Aliases**
   - Containers: `web` and `app`
   - Aliases: `web`, `app`

6. **Tested Container Communication**
   - Pinged `web` from `app` to verify networking.

7. **Network Alias Example**
   - Container `db` with network alias `database`
   - Pinged `database` from `app` to verify alias works.

8. **Documented Architecture**
   - Added diagram showing containers, volumes, and network connections.

---

## Data Persistence Proof

The file `data.txt` was created in `/app_data` inside `volume_container`.  
After removing the container and running `new_container` with the same volume, the file still exists:

`screenshots/data_persisted.png`

---

## Network Communication Proof

Containers `web` and `app` on the custom network `my_network` can communicate using container names:

`screenshots/container_communication.png`

---

## Architecture Diagram

          +-------------------------+
          |      Docker Network     |
          |        "my_network"    |
          +-------------------------+
           |           |           |
       +-------+   +-------+   +-------+
       | web   |   | app   |   | db    |
       +-------+   +-------+   +-------+
                        |
                   Alias: database
                        |
          +---------------------------+
          |       Volume: my_volume   |
          |     Mounted at /app_data  |
          +---------------------------+



---

## Commands Used

```bash
# Create volume
docker volume create my_volume

# Run first container with volume
docker run -d --name volume_container -v my_volume:/app_data nginx

# Store data inside container
docker exec -it volume_container bash
echo "Docker volume persistence test" > /app_data/data.txt
cat /app_data/data.txt

# Remove container to test persistence
docker rm -f volume_container

# Run new container with same volume
docker run -d --name new_container -v my_volume:/app_data nginx
docker exec -it new_container cat /app_data/data.txt

# Create custom network
docker network create my_network

# Run containers on network
docker run -d --name web --network my_network nginx
docker run -d --name app --network my_network alpine sleep 1000

# Test container communication
docker exec -it app ping web

# Network alias example
docker run -d --name db --network my_network --network-alias database mysql
docker exec -it app ping database

# Inspect volume and network
docker volume inspect my_volume
docker network inspect my_network

# Remove containers but keep volume
docker rm -f web app new_container
docker volume ls
