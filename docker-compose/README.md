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

| Container Name               | Date Tested | Working on Dev | Deployed | Docker Network    | IP           | External Port                                         |
|------------------------------|-------------|----------------|----------|-------------------|--------------|-------------------------------------------------------|
| AdGuard                      | 12/28/2023  | Yes            | Yes      | br0               | Custom IP    | 53, 67, 68, 80, 443, 784, 853, 3000, 5443, 6060, 8853 |
| authentik                    | 5/1/2023    | Yes            | No       | ${DOCKER_NETWORK} | ${SERVER_IP} | 9000, 9443                                            |
| authentik-worker             | 5/1/2023    | Yes            | No       | ${DOCKER_NETWORK} | 0.0.0.0      | N/A                                                   |
| BookStack                    | 5/4/2024    | Yes            | Yes      | ${DOCKER_NETWORK} | ${SERVER_IP} | 6875                                                  |
| bookstack_db                 | 5/4/2024    | Yes            | Yes      | ${DOCKER_NETWORK} | ${SERVER_IP} | 3307                                                  |
| Czkawka                      | 12/28/2023  | Yes            | Yes      | bridge            | ${SERVER_IP} | 7821, 7921                                            |
| ClamAV (used with PingVin)   | 5/18/2024   | Yes            | Yes      | ${DOCKER_NETWORK} | ${SERVER_IP} | N/A                                                   |
| CloudflareDDNS               | 12/28/2023  | Yes            | Yes      | ${DOCKER_NETWORK} | 0.0.0.0      | ???                                                   |
| dawarich                     | 1/21/2024   | Yes            | Yes      | ${DOCKER_NETWORK} | ${SERVER_IP} | 7654                                                  |
| delugevpn                    | 11/20/2022  | Yes            | Yes      | ${DOCKER_NETWORK} | ${SERVER_IP} | 8112, 8118, 58846, 58946                              |
| DiskSpeed                    | N/A         | Yes            | Yes      | bridge            | ${SERVER_IP} | 18888                                                 |
| Filebrowser                  | 4/30/2024   | Yes            | No       | ${DOCKER_NETWORK} | ${SERVER_IP} | 1987                                                  |
| Flaresolverr                 | 1/7/2024    | Yes            | Yes      | ${DOCKER_NETWORK} | ${SERVER_IP} | 8191                                                  |
| Homepage                     | 3/16/2024   | Yes            | Yes      | ${DOCKER_NETWORK} | ${SERVER_IP} | 3000                                                  |
| Home Assistant               | 12/19/2023  | Yes            | Yes      | ${DOCKER_NETWORK} | ${SERVER_IP} | 8123                                                  |
| Immich                       | 4/6/2024    | Yes            | Yes      | ${DOCKER_NETWORK} | ${SERVER_IP} | 6781                                                  |
| Jellyfin                     | 3/21/2024   | Yes            | Yes      | ${DOCKER_NETWORK} | ${SERVER_IP} | 1900, 8096, 8920                                      |
| Jellyseer                    | 3/21/2024   | Yes            | Yes      | ${DOCKER_NETWORK} | ${SERVER_IP} | 5055                                                  |
| Jetlog                       | 7/25/2024   | Yes            | Yes      | ${DOCKER_NETWORK} | ${SERVER_IP} | 8914                                                  |
| Jackett                      | 12/28/2023  | Yes            | No       | ${DOCKER_NETWORK} | ${SERVER_IP} | 9117                                                  |
| Krusader                     | 12/28/2023  | Yes            | No       | ${DOCKER_NETWORK} | ${SERVER_IP} | 6481                                                  |
| Memos                        | 11/02/2024  | Yes            | Yes      | ${DOCKER_NETWORK} | ${SERVER_IP} | 5230                                                  |
| MariaDB                      | 12/29/2023  | Yes            | Yes      | ${DOCKER_NETWORK} | ${SERVER_IP} | 3306                                                  |
| Nextcloud                    | 12/29/2023  | Yes            | No       | ${DOCKER_NETWORK} | ${SERVER_IP} | 444                                                   |
| nextcloud_db                 | N/A         | Yes            | No       | ${DOCKER_NETWORK} | ${SERVER_IP} | 3306                                                  |
| NextCloud AIO                | 4/29/2024   | Yes            | No       | ${DOCKER_NETWORK} | ${SERVER_IP} | N/A                                                   |
| NginxProxyManager            | N/A         | Yes            | Yes      | ${DOCKER_NETWORK} | ${SERVER_IP} | 4443, 8080, 8181                                      |
| Paperless-ngx                | 10/26/2024  | Yes            | Yes      | ${DOCKER_NETWORK} | ${SERVER_IP} | 8138                                                  |
| Photoprism                   | 4/5/2024    | Yes            | Yes      | ${DOCKER_NETWORK} | ${SERVER_IP} | 2342                                                  |
| Pingvin-Share                | 5/18/2024   | Yes            | Yes      | ${DOCKER_NETWORK} | ${SERVER_IP} | 4981                                                  |
| prowlarr                     | 3/21/2024   | Yes            | Yes      | ${DOCKER_NETWORK} | ${SERVER_IP} | 9696                                                  |
| qBittorrent                  | 12/21/2023  | Yes            | Yes      | ${DOCKER_NETWORK} | ${SERVER_IP} | 9519                                                  |
| radarr                       | 12/28/2023  | Yes            | Yes      | ${DOCKER_NETWORK} | ${SERVER_IP} | 7878                                                  |
| redis                        | N/A         | Yes            | Yes      | ${DOCKER_NETWORK} | ${SERVER_IP} | 6379                                                  |
| redis_immich                 | N/A         | No             | No       | ${DOCKER_NETWORK} | ${SERVER_IP} | 6380                                                  |
| scrutiny                     | 12/28/2023  | Yes            | Yes      | bridge            | ${SERVER_IP} | 1977                                                  |
| SFTPGO                       | 11/17/2024  | Yes            | No       | ${DOCKER_NETWORK} | ${SERVER_IP} | 2221                                                  |
| syncthing                    | 6/7/2024    | Yes            | Yes      | ${DOCKER_NETWORK} | ${SERVER_IP} | 8384, 22000, 21027                                    |
| UniFi-Protect-Backup         | 5/1/2023    | Yes            | Yes      | ${DOCKER_NETWORK} | 0.0.0.0      | N/A                                                   |
| UptimeKuma                   | 7/5/2023    | Yes            | Yes      | ${DOCKER_NETWORK} | ${SERVER_IP} | 3001                                                  |
| wikijs                       | 5/4/2024    | Yes            | Yes      | ${DOCKER_NETWORK} | ${SERVER_IP} | 3256                                                  |
| wikijs_db                    | 5/4/2024    | Yes            | Yes      | ${DOCKER_NETWORK} | 0.0.0.0      | 5432                                                  |
