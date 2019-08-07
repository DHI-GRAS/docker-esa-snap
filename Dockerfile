FROM debian:latest

USER root

RUN apt-get update && \
    apt-get -y install \
      'wget' 'libgfortran3'

# install snap
RUN wget http://step.esa.int/downloads/7.0/installers/esa-snap_sentinel_unix_7_0.sh && \
    sh esa-snap_sentinel_unix_7_0.sh -q && \
    rm esa-snap_sentinel_unix_7_0.sh

# update snap
RUN snap --nosplash --nogui --modules --update-all

# set gpt max memory to 32GB
RUN sed -i -e 's/-Xmx1G/-Xmx32G/g' /usr/local/snap/bin/gpt.vmoptions

WORKDIR /work
RUN chmod 777 /work

# set s3tbx readers to per-pixel geocoding
COPY s3tbx.properties /usr/local/snap/etc/s3tbx.properties

# set entrypoint
ENTRYPOINT ["/usr/local/snap/bin/gpt"]
CMD ["-h"]
