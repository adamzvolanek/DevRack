# DevRack Docker-Compose

This ReadMe will go over how to deploy the entire stack. Once a 'compose-up' is issued for each stack, please follow the documentation to continue following along. Link Pending however will be utilinzing of the services in the [docs](/docker-compose/docs/) directory.

## Using docker-compose plugin on Unraid

Installation on Unraid currently follows the use of the [following](https://github.com/dcflachs/compose_plugin) docker-compose plugin mentioned.

The plugin will appear at the bottom of your currently deployed docker containers under the Docker tab in your Unraid instance.

### **Limitations**

Include having to combine the [`server.env`](../docker-compose/server.env) and stack specific envirnonment files into a single file.

Likewise, having to create the docker network ahead of time to prevent errors when issuing 'Compose Down' and during first container creation. Until an order or priority of docker containers is established, the creation of the network is necessary independently of the stack being deployed.

### Creation of Docker Network

Open the unraid terminal and run, `docker network create <DOCKER_NETWORK>`.

### Setup of Docker-Compose Plugin

- Select 'Add New Stack' and give it a name
  - Select 'OK' once created
- On the cog-wheel of the newly created stack and edit the Name and Description as desired.
- Select 'Edit Stack' to enter a sub-menu.
  - Select 'Compose File' and copy/paste the respective compose file from the repository
    - Click 'Save Changes'
  - Select 'Env File' and paste **both** the [`server.env`](../docker-compose/server.env) file's contents and any respective local environment file.
- Select the stack, click 'Edit Stack', and click 'UI Labels'
  - In the front-end service, enter the WebUI and Port you expect to see the application in. e.g. `http://192.168.1.XX:Port` or (when filling in the values) `http://<SERVER_IP>:<PORT>`.
  - You may also choose to add an Icon in the same menu. Link to the *.image_extension itself.
- Click 'Compose Up' to deploy the stack.
- Allow the window to remain open during 'Compose Up/Down' commands.
