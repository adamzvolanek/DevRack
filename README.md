# DevRack

The title is still a work in progress. This is a project consisting of both self-learning and creating repeatable, deployable code that exists on my Unraid server: Alexandria. An effort to remove myself from the 'simplified' UI of dockers in Unraid, VMs, and other running tools.

Likewise, creation of VMs, testing Ansible scripts, and in the future, configuration scripts for the docker containers themselves. An end goal of a 1-click deployment of my dockers and VMs, already configured to any platform that supports docker/docker-compose.

## Getting Started

While this repository was not made to distribute or really be written in a way for others to use. As I am learning the abstract-ness of the code is not beyond most people's understanding and others are free to pick-up and use my work; download the Docker-Compose folder and there will be included my .env file which is used throughout the stacks inside of the Docker-Compose folder.

Please take a look at my [Dev Rack Project](https://github.com/users/adamzvolanek/projects/1) under the Alexandria board to view my current progress, completion, and future work.

### Prerequisites

Currently, I am testing these docker-compose stacks on my Unraid server, however theoretically any compute platform (EC2s for example) that is capable of running docker, 37.6 Gb for (my current) docker image, and 10 Gb of RAM with the dockers running.


## Built With

* [Unraid](https://unraid.net/) - Server, test-bed, and host
* [compose_plugin](https://github.com/dcflachs/compose_plugin) - Docker-Compose plugin for Unraid
* [Pre-Commit](https://pre-commit.com/) - Keeping code tidy and stepping away from github actions (after the fact)
* [Notepad++](https://notepad-plus-plus.org/) - Used to write yaml files.

## Contributing

Please read [CONTRIBUTING.md](https://github.com/adamzvolanek/DevRack/blob/906fd7d4a2b8d2abc9baf3908f005e6e2d9973b6/CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

One day I will implement better versioning, but happy to take suggestions. I haven't hit my 'first release' but this will be a continued personal project so not a high priority.

## Authors

* **Adam Zvolanek**

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* A special thanks for those that maintain the docker containers I use and reference. Without you, I would not have started on this journey. A special thanks to those that create wonderful installation documentation and at times include a docker-compose file already.
* A thanks goes out to the YouTube channels I follow ot begin this NAS journey, and to those at work that encouraged me to simply try. My work has allowed me to enter the cloud space specifically, but without my foundational knowledge and continued interest, I would not have the job I currently have.
* A last thanks to those that have supported me: my awesome group of friends from highschool, my girlfriend, and those that say I can't do something.

## Shameless Plug

Blog Link
