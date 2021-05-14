# Digital Ocean Dynamic DNS Updater

<!-- @import "[TOC]" {cmd="toc" depthFrom=2 depthTo=6 orderedList=false} -->

## Purpose

Allows to dynamically update an 'A' or 'AAAA' record that is managed by Digital Ocean's DNS servers.

Main purpose of this is to keep a known domain for your home IP address. For instance, if your ISP doesn't give you an static IP address, you could run this script with `--run-every` flag, in a cron job or with the Windows Scheduler to keep an always available domain pointing to your home IP.

## Usage

The script has been designed to be called as a command line tool. Config is passed into it in the form of CLI parameters, for example:

```sh
python app/updater.py {accessToken} {domain} {record} {recordType} {other args}
```

Where:

- `accessToken`: your Digital Ocean ['Personal Access Token'](https://cloud.digitalocean.com/settings/applications)
- `domain`: the domain name you want to update (e.g: yourdomain.com)
- `record`: the value of the record you want to update (e.g: home)
- `recordType`: either A or AAAA
- `-q` / `--quiet`: quiet mode, only displays output on IP change
- `-d` / `--debug`: debug mode, shows debug messages, more
- `-re {seconds}` / `--run-every {seconds}`: runs continuously every number of seconds
- `ecoc` / `--error-code-on-change`: returns error code 1 on IP change

### Run Continuously / Cron Style

You can run this script continuously (every X number of seconds) by calling it like below:

```sh
# If you wan to run it every 5 minutes
python app/updater.py {accessToken} {domain} {record} {recordType} --run-every 300
```

## Docker

### Official Docker Image

You can use the official Docker image directly from Docker Hub without having to clone this repo.

You can use the provided [docker-compose.yml](docker-compose.yml) file to run it, just download the file, create a `.env` file next to it (see [.env.sample](.env.sample)) and run:

```sh
# Runs the service in detached mode
docker-compose up -d
```

Or if you prefer, you can just use a bash script like the following:

```sh
IMAGE=yorch/do-ddns-updater
CONTAINER_NAME=do-ddns-updater
TOKEN={your token}
DOMAIN={your domain}
RECORD={your record}
RTYPE=A
RUN_EVERY=300 # Every 5 min

docker run \
    -d \
    --name ${CONTAINER_NAME} \
    --restart=unless-stopped \
    ${IMAGE} \
    ${TOKEN} ${DOMAIN} ${RECORD} ${RTYPE} --run-every ${RUN_EVERY}
```

### Docker build

To build the image using the provided [Dockerfile](Dockerfile), run the following:

```sh
docker build -t do-ddns-updater .
```

Then, you can run your new image with something like:

```sh
IMAGE=do-ddns-updater
TOKEN={your token}
DOMAIN={your domain}
RECORD={your record}
RTYPE=A
RUN_EVERY=300 # Every 5 min

docker run \
    -d \
    --restart=unless-stopped \
    ${IMAGE} \
    ${TOKEN} ${DOMAIN} ${RECORD} ${RTYPE} --run-every ${RUN_EVERY}
```

Or with Docker Compose:

```yaml
version: "3.7"

services:
  do-ddns-updater:
    image: do-ddns-updater
    env_file: .env
    command: ${TOKEN} ${DOMAIN} ${RECORD} ${RTYPE} --run-every ${RUN_EVERY}
```

You can even build it and run it directly with Docker Compose:

```yaml
version: "3.7"

services:
  do-ddns-updater:
    build: .
    env_file: .env
    command: ${TOKEN} ${DOMAIN} ${RECORD} ${RTYPE} --run-every ${RUN_EVERY}
```

## Credits

Originally forked from: https://github.com/bensquire/Digital-Ocean-Dynamic-DNS-Updater
