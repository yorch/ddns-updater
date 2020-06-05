# Digital Ocean Dynamic DNS Updater

## Purpose:

Allows the dynamic updating of an 'A' or 'AAAA' record that is managed by Digital Ocean's DNS servers.

Probably the main purpose of this is to keep a known domain for your home IP address. For instance, if
your ISP doesn't give you an static IP address, you could run this script in a cron job, with the Windows
Scheduler or use the `--run-every` flag to keep an always available domain pointing to your home.

## Usage:

The script has been designed to be called as a command line tool. Config is passed into it in the form of CLI parameters, for example:

```sh
python app/updater.py {accessToken} {domain} {record} {recordType}
```

Where:

- `accessToken` is your Digital Ocean ['Personal Access Token'](https://cloud.digitalocean.com/settings/applications)
- `domain` is the domain name you want to update (e.g: yourdomain.com)
- `record` is the value of the record you want to update (e.g: home)
- `recordtype` is either A or AAAA

## Run Continuously / Cron Style:

You can run this script continuously (every X number of seconds) by calling it like below:

```sh
# If you wan to run it every 5 minutes
python app/updater.py {accessToken} {domain} {record} {recordType} --run-every 300
```

### Docker Compose

A `docker-compose.yml` file is included in this repo, so you can run it in any machine with Docker installed.

Only need to create a `.env` file (you can copy `.env.sample`) with your API access token and the rest
of the options, and then called:

```sh
# Run the service in detached mode
docker-compose -d up
```

### Docker

You can also run it without Compose, by using something like:

```sh
IMAGE=python:3.8-alpine
CONTAINER_NAME=do-ddns-updater
CONTAINER_WORKDIR=/app
TOKEN={your token}
DOMAIN={your domain}
RECORD={your record}
RTYPE=A
TIMEOUT=300 # Every 5 min
# -u is needed so stdout can be viewed through docker logs
# PYTHONUNBUFFERED=0 accomplish the same, so it's redundant
CMD="python -u updater.py ${TOKEN} ${DOMAIN} ${RECORD} ${RTYPE} --run-every ${TIMEOUT}"

docker run \
    -d \
    -e PYTHONUNBUFFERED=0 \
    --name ${CONTAINER_NAME} \
    -v "${PWD}"/app:${CONTAINER_WORKDIR} \
    -w ${CONTAINER_WORKDIR} \
    --restart=unless-stopped \
    ${IMAGE} \
    ${CMD}
```

## Credits

Originally forked from: https://github.com/bensquire/Digital-Ocean-Dynamic-DNS-Updater
