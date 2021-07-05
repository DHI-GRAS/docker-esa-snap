FROM debian:buster

#USER root

RUN apt-get update && apt-get -y install wget procps fonts-dejavu fontconfig libgfortran5

# install snap
RUN wget http://step.esa.int/downloads/8.0/installers/esa-snap_sentinel_unix_8_0.sh && \
    sh esa-snap_sentinel_unix_8_0.sh -q && \
    rm esa-snap_sentinel_unix_8_0.sh

RUN snap --nosplash --nogui --modules --list

# update snap modules
RUN snap --nosplash --nogui --modules --update-all 2>&1 | while read -r line ; do echo "$line" ; [ "$line" = "updates=0" ] && sleep 2 && ps aux && killall -9 "java" ; done ; echo "be happy"

#RUN useradd manfred
#USER manfred

ENV LD_LIBRARY_PATH ".:$LD_LIBRARY_PATH"

# set s3tbx readers to per-pixel geocoding
COPY s3tbx.properties /usr/local/snap/etc/s3tbx.properties
COPY snap.properties /usr/local/snap/etc/snap.properties

# set entrypoint
ENTRYPOINT ["/usr/local/snap/bin/gpt"]
CMD ["-h"]
