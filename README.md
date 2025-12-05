# DevRack

This is my home-lab project consisting of deployable code that exists on my Unraid server named, Alexandria. My end goal of a near "1-click" deployment of dockers and VMs, already configured to deploy in Unraid.

## Getting Started

This repository was not made to distribute these services, please always refer to the original authors of each container.

Please take a look at my [Dev Rack Project](https://github.com/users/adamzvolanek/projects/1) under the Alexandria board to view my current progress, completion, and future work.

### Built Using

* [Unraid](https://unraid.net/) - Server, test-bed, and host
* [compose_plugin](https://github.com/dcflachs/compose_plugin) - Docker-Compose plugin for Unraid

## Running this for yourself

If you are wanting to try this for yourself, please read the docker-compose [readme](/docker-compose/README.md) carefully. The instructions are written for use in Unraid and you **will** have to replace all the values in each respective `*.env` file to meet **YOUR** needs.

## Running Containers

| Container Name               | External Port                                         |
|------------------------------|-------------------------------------------------------|
| AdGuard                      | 53, 67, 68, 80, 443, 784, 853, 3000, 5443, 6060, 8853 |
| AirTrail                     | 5432                                                  |
| Beszel                       | 8090                                                  |
| BookStack                    | 6875                                                  |
| bookstack_db                 | 3307                                                  |
| CloudflareDDNS               | N/A                                                   |
| Dawarich                     | 7654                                                  |
| Dozzle                       | 7070                                                  |
| DumbDrop                     | 9515                                                  |
| QbitTorreent                 | 6881, 9519, 8118                                      |
| DiskSpeed                    | 18888                                                 |
| Flaresolverr                 | 8191                                                  |
| Homepage                     | 3000                                                  |
| Immich                       | 6781                                                  |
| Jellyfin                     | 1900, 8096, 8920                                      |
| Jellyseer                    | 5055                                                  |
| Memos                        | 5230                                                  |
| MariaDB                      | 3306                                                  |
| NginxProxyManager            | 4443, 8080, 8181                                      |
| Paperless-ngx                | 8138                                                  |
| Photoprism                   | 2342                                                  |
| prowlarr                     | 9696                                                  |
| radarr                       | 7878                                                  |
| redis                        | 6379                                                  |
| scrutiny                     | 1977                                                  |
| syncthing                    | 8384, 22000, 21027                                    |
| UniFi-Protect-Backup         | N/A                                                   |
| UptimeKuma                   | 3001                                                  |

## Contributing

Please read [CONTRIBUTING.md](https://github.com/adamzvolanek/DevRack/blob/main/CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Authors

* **Adam Zvolanek**

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* A special thanks for those that maintain the docker containers I use and reference: [linuxserver](https://www.linuxserver.io/), [binhex](https://github.com/binhex), [ich777](https://github.com/ich777) and many more.
* All the YouTube channels that create tutorials and walk-throughs of all things Unraid and dockers.
* A last thanks to those that have supported me: my awesome group of friends from highschool, my ~~girlfriend~~ ~~fiance~~ wife, and those that say I can't do something.
