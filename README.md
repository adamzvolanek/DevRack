# DevRack

This is my home-lab project consisting of both self-learning and creating repeatable, deployable code that exists on my Unraid server named, Alexandria. My end goal of a "1-click" deployment of dockers and VMs, already configured to deploy in Unraid.

## Getting Started

While this repository was not made to distribute or really be written in a way for others to use. As I am learning the abstract-ness of the code is not beyond most people's understanding and others are free to pick-up and use my work; download the Docker-Compose folder and there will be included my .env file which is used throughout the stacks inside of the Docker-Compose folder.

Please take a look at my [Dev Rack Project](https://github.com/users/adamzvolanek/projects/1) under the Alexandria board to view my current progress, completion, and future work.

### Prerequisites

Currently, I am testing these docker-compose stacks on my Unraid server, however theoretically any compute platform that is capable of running docker, 37.6 Gb for (my current) docker image, and 10 Gb of RAM with the dockers running.

### Built Using

* [Unraid](https://unraid.net/) - Server, test-bed, and host
* [compose_plugin](https://github.com/dcflachs/compose_plugin) - Docker-Compose plugin for Unraid
* [Pre-Commit](https://pre-commit.com/) - Keeping code tidy and stepping away from GitHub actions (after the fact)

## Running this for yourself

If you are wanting to try this for yourself, please read the docker-compose [readme](/docker-compose/README.md) carefully. The instructions are written for use in Unraid and you **will** have to replace all the values in each respective `*.env` file to meet **YOUR** needs.

## Testing Status

| Container Name               | External Port                                         |
|------------------------------|-------------------------------------------------------|
| AdGuard                      | 53, 67, 68, 80, 443, 784, 853, 3000, 5443, 6060, 8853 |
| Beszel                       | 8090                                                  |
| BookStack                    | 6875                                                  |
| bookstack_db                 | 3307                                                  |
| Czkawka                      | 7821, 7921                                            |
| ClamAV (used with Pingvin)   | N/A                                                   |
| CloudflareDDNS               | N/A                                                   |
| QBitTorrentVPN               | 7984, 8118, 58846, 58946                              |
| DiskSpeed                    | 18888                                                 |
| Flaresolverr                 | 8191                                                  |
| Homepage                     | 3000                                                  |
| Home Assistant               | 8123                                                  |
| Immich                       | 6781                                                  |
| Jellyfin                     | 1900, 8096, 8920                                      |
| Jellyseer                    | 5055                                                  |
| Jetlog                       | 8914                                                  |
| Memos                        | 5230                                                  |
| MariaDB                      | 3306                                                  |
| NginxProxyManager            | 4443, 8080, 8181                                      |
| Paperless-ngx                | 8138                                                  |
| Photoprism                   | 2342                                                  |
| Pingvin-Share                | 4981                                                  |
| prowlarr                     | 9696                                                  |
| radarr                       | 7878                                                  |
| redis                        | 6379                                                  |
| scrutiny                     | 1977                                                  |
| syncthing                    | 8384, 22000, 21027                                    |
| UniFi-Protect-Backup         | N/A                                                   |
| UptimeKuma                   | 3001                                                  |

## Contributing

Please read [CONTRIBUTING.md](https://github.com/adamzvolanek/DevRack/blob/main/CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

Pending.

## Authors

* **Adam Zvolanek**

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* A special thanks for those that maintain the docker containers I use and reference: [linuxserver](https://www.linuxserver.io/), [binhex](https://github.com/binhex), [ich777](https://github.com/ich777) and many more.
* All the YouTube channels that create tutorials and walk-throughs of all things Unraid and dockers.
* A last thanks to those that have supported me: my awesome group of friends from highschool, my ~~girlfriend~~ ~~fiance~~ wife, and those that say I can't do something.
