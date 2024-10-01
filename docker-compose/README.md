# DevRack Docker-Compose

This covers how to deploy the entire stack via docker-compose. Once a 'compose-up' is issued for each stack, please follow the respective dockers documentation by following my [BookStack Instance](https://docs.adamzvolanek.com) or [WikiJS Instance](https://wiki.adamzvolanek.com). Both will have identical content.

## Using docker-compose plugin on Unraid

Installation on Unraid currently follows the use of the [following](https://github.com/dcflachs/compose_plugin) docker-compose plugin mentioned.

The plugin will appear at the bottom of your currently deployed docker containers under the Docker tab in your Unraid instance.

### **Limitations**

Include having to combine the [`server.env`](../docker-compose/server.env) and stack specific environment files into a single file.

Likewise, having to create the docker network ahead of time to prevent errors when issuing 'Compose Down' and during first container creation. Until an order or priority of docker containers is established, the creation of the network is necessary independently of the stack being deployed.

### Setup of Docker-Compose Plugin

- Select 'Add New Stack' and give it a name
- (Optionally) Select 'Advanced' and provide the location of where to store the `yml` file on Unraid itself.
  - Select 'OK' once created
- On the cog-wheel of the newly created stack and edit the Name and Description as desired.
- Select 'Edit Stack' to enter a sub-menu.
  - Select 'Compose File' and copy/paste the respective compose file from the repository
    - Click 'Save Changes'.
  - Select 'Env File' and paste **both** the [`server.env`](../docker-compose/server.env) file's contents and any respective local environment file.
- Select the stack, click 'Edit Stack', and click 'UI Labels'.
  - In the frontend service, enter the WebUI and Port you expect to see the application in. e.g. `http://192.168.1.XX:Port` or (when filling in the values) `http://<SERVER_IP>:<PORT>`.
  - You may also choose to add an Icon in the same menu. Link to the *.image_extension itself.
- Click 'Compose Up' to deploy the stack.
- Allow the window to remain open during 'Compose Up/Down' commands.

## Port Configuration

|Container Name              |Docker Network   |IP          |External Port                                        |
|----------------------------|-----------------|------------|-----------------------------------------------------|
|adguard                     |br0              |Custom IP   |53, 67, 68, 80, 443, 784, 853, 3000, 5443, 6060, 8853|
|authentik                   |${DOCKER_NETWORK}|${SERVER_IP}|9000, 9443                                           |
|authentik-worker            |${DOCKER_NETWORK}|0.0.0.0     |                                                     |
|binhex-readarr              |${DOCKER_NETWORK}|${SERVER_IP}|2194                                                 |
|BookStack                   |${DOCKER_NETWORK}|${SERVER_IP}|6875                                                 |
|bookstack_db                |${DOCKER_NETWORK}|${SERVER_IP}|3307                                                 |
|ClamAV (used with PingVin)  |${DOCKER_NETWORK}|${SERVER_IP}|N/A                                                  |
|Cloudflare_DDNS             |${DOCKER_NETWORK}|0.0.0.0     |???                                                  |
|Czkawka                     |bridge           |${SERVER_IP}|7821, 7921                                           |
|delugevpn                   |${DOCKER_NETWORK}|${SERVER_IP}|8112, 8118, 58846, 58946                             |
|DiskSpeed                   |bridge           |${SERVER_IP}|18888                                                |
|DockerWebUI                 |${DOCKER_NETWORK}|${SERVER_IP}|1111                                                 |
|Filebrowser                 |${DOCKER_NETWORK}|${SERVER_IP}|634                                                  |
|Flaresolverr                |${DOCKER_NETWORK}|${SERVER_IP}|8191                                                 |
|Home Assistant              |${DOCKER_NETWORK}|${SERVER_IP}|8123                                                 |
|Homepage                    |${DOCKER_NETWORK}|${SERVER_IP}|3000                                                 |
|immich                      |${DOCKER_NETWORK}|${SERVER_IP}|6781                                                 |
|jackett                     |${DOCKER_NETWORK}|${SERVER_IP}|9117                                                 |
|Jellyfin                    |${DOCKER_NETWORK}|${SERVER_IP}|1900, 8096, 8920                                     |
|Jellyseerr                  |${DOCKER_NETWORK}|${SERVER_IP}|5055                                                 |
|Jetlog                      |${DOCKER_NETWORK}|${SERVER_IP}|8914                                                 |
|Krusader                    |${DOCKER_NETWORK}|${SERVER_IP}|6481                                                 |
|lidarr                      |${DOCKER_NETWORK}|${SERVER_IP}|8686                                                 |
|luckyBackup                 |bridge           |${SERVER_IP}|2385                                                 |
|nextcloud_db                |${DOCKER_NETWORK}|${SERVER_IP}|3306                                                 |
|nextcloud                   |${DOCKER_NETWORK}|${SERVER_IP}|444                                                  |
|NginxProxyManager           |${DOCKER_NETWORK}|${SERVER_IP}|4443, 8080, 8181                                     |
|Paperless-ngx               |${DOCKER_NETWORK}|${SERVER_IP}|8138                                                 |
|Pingvin-share               |${DOCKER_NETWORK}|${SERVER_IP}|4981                                                 |
|Photoprism                  |${DOCKER_NETWORK}|${SERVER_IP}|2342                                                 |
|phpmyadmin                  |bridge           |${SERVER_IP}|8070                                                 |
|postgres_authentik          |${DOCKER_NETWORK}|${SERVER_IP}|5432                                                 |
|postgres_immich             |${DOCKER_NETWORK}|${SERVER_IP}|5433                                                 |
|prowlarr                    |${DOCKER_NETWORK}|${SERVER_IP}|9696                                                 |
|qBittorrent                 |${DOCKER_NETWORK}|${SERVER_IP}|8089                                                 |
|radarr                      |${DOCKER_NETWORK}|${SERVER_IP}|7878                                                 |
|redis                       |${DOCKER_NETWORK}|${SERVER_IP}|6379                                                 |
|redis_immich                |${DOCKER_NETWORK}|${SERVER_IP}|6380                                                 |
|scrutiny                    |bridge           |${SERVER_IP}|1977                                                 |
|sonarr                      |${DOCKER_NETWORK}|${SERVER_IP}|8989                                                 |
|syncthing                   |${DOCKER_NETWORK}|${SERVER_IP}|8384, 22000, 21027                                   |
|UniFi-Protect-Backup        |${DOCKER_NETWORK}|0.0.0.0     |                                                     |
|UptimeKuma                  |${DOCKER_NETWORK}|${SERVER_IP}|3001                                                 |
|wikijs                      |${DOCKER_NETWORK}|${SERVER_IP}|3256                                                 |
|wikijs_db                   |${DOCKER_NETWORK}|0.0.0.0     |5432                                                 |
