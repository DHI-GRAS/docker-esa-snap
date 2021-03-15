FROM debian:buster

USER root

RUN apt-get update && apt-get -y install wget procps fonts-dejavu fontconfig

# install snap
RUN wget http://step.esa.int/downloads/8.0/installers/esa-snap_sentinel_unix_8_0.sh && \
    sh esa-snap_sentinel_unix_8_0.sh -q && \
    rm esa-snap_sentinel_unix_8_0.sh

# update snap
RUN snap --nosplash --nogui --modules --list --refresh
RUN snap --nosplash --nogui --modules --update-all 2>&1 | while read -r line ; do echo "$line" [ "$line" = "updates=0" ] && sleep 2 && pkill -TERM -f "snap/jre/bin/java" ; done

# set gpt max memory to 32GB
RUN sed -i -e 's/-Xmx1G/-Xmx32G/g' /usr/local/snap/bin/gpt.vmoptions

WORKDIR /work
RUN chmod 777 /work

ENV LD_LIBRARY_PATH ".:$LD_LIBRARY_PATH"

# set s3tbx readers to per-pixel geocoding
COPY s3tbx.properties /usr/local/snap/etc/s3tbx.properties

# set entrypoint
ENTRYPOINT ["/usr/local/snap/bin/gpt"]
CMD ["-h"]
