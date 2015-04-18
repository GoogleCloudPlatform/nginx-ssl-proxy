FROM nginx

WORKDIR /usr/src

ADD . /usr/src/

ENTRYPOINT ./run.sh
