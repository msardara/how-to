# How to expose port on running docker container

Docker containers are cool, but sometimes they do not allow you to do simple operations like expose ports while the container is already running.

Here is a workaround for it:

```bash
DOCKER_IP=<The ip of the docker container where the service is running on>
DESTINATION_PORT=<The port of the service>

iptables -t nat -A DOCKER -p tcp --dport ${DESTINATION_PORT} -j DNAT --to-destination ${DOCKER_IP}:${DESTINATION_PORT}
iptables -t nat -A POSTROUTING -j MASQUERADE -p tcp --source ${DOCKER_IP} --destination ${DOCKER_IP} --dport ${DESTINATION_PORT}
iptables -A DOCKER -j ACCEPT -p tcp --destination ${DOCKER_IP} --dport ${DESTINATION_PORT}
```
