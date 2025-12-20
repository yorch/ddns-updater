FROM python:3.14-alpine
LABEL maintainer="jorge.barnaby@gmail.com"

# So stdout can be viewed through docker logs
ENV PYTHONUNBUFFERED=0

WORKDIR /app

ADD app/ .

ENTRYPOINT [ "python", "-u", "updater.py" ]
