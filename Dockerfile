FROM rocker/verse:latest

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
                                              libpoppler-cpp-dev \

