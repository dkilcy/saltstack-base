
### Docker Cheatsheet

Images vs Containers:

- An instance of an image is called a container.
- If you start this image, you have a running container of this image.
- You can have many running containers of the same image.

Docker Command Summary:

- Add user to docker group: `usermod -aG docker ironman`
- Show running containers: `docker ps`
- Show all containers: `docker ps -a`
- Start bash session in container: `docker exec -it <name> /bin/bash`
- Run container: `docker run -d --name <name> <repository>`
- Start container: `docker start <name>`
- Inspect container: `docker inspect <name>`
- View port mappings: `docker port <name>`
- Show container logs: `docker logs <name>`
- Get Container ID of the container you are in: 
```
cat /proc/self/cgroup | grep -o  -e "docker-.*.scope" | head -n 1 | sed "s/docker-\(.*\).scope/\\1/"`
```
- Stop container: `docker stop <name>`
- Remove all docker containers: `docker rm $(docker ps -a -q)`
- Remove all docker images: `docker rmi $(docker images -q)`

### References

- [Engine reference](https://docs.docker.com/engine/reference/)
