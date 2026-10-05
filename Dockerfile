FROM debian:bookworm-slim

RUN apt-get update && apt-get -y install wget procps fonts-dejavu fontconfig libgfortran5 && \
    rm -rf /var/lib/apt/lists/*

# install snap
RUN wget https://download.esa.int/step/snap/13.0/installers/esa-snap_sentinel_linux-13.0.0.sh && \
    sh esa-snap_sentinel_linux-13.0.0.sh -q && \
    rm esa-snap_sentinel_linux-13.0.0.sh

# update snap modules
RUN snap --nosplash --nogui --modules --update-all 2>&1 | while read -r line ; do echo "$line" ; [ "$line" = "updates=0" ] && sleep 2 && ps aux && killall -9 "java" ; done ; echo "be happy"

WORKDIR /work
RUN chmod 777 /work
ENV LD_LIBRARY_PATH=".:${LD_LIBRARY_PATH:-}"

# set s3tbx readers to per-pixel geocoding
COPY s3tbx.properties /usr/local/snap/etc/s3tbx.properties

# set entrypoint
ENTRYPOINT ["/usr/local/esa-snap/bin/gpt"]
CMD ["-h"]
