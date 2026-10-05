# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This repository builds a Docker image containing ESA SNAP (Sentinel Application Platform) with all Sentinel toolboxes (S1TBX, S2TBX, S3TBX, SMOS Box, PROBA-V). The image is published to Docker Hub as `dhigras/esa-snap`. The entrypoint is the `gpt` (Graph Processing Tool) command-line tool.

## Branch Convention

Branches track SNAP major versions: `snap-11`, `snap-12`, `snap-13`. When upgrading SNAP, create a new branch matching the version.

## Common Commands

**Build the image:**
```sh
docker build -t dhigras/esa-snap .
```

**Test the image (print GPT help):**
```sh
docker run --rm dhigras/esa-snap
```

**Run a GPT graph:**
```sh
docker run --rm -v /path/to/data:/work dhigras/esa-snap MyGraph.xml
```

**Push to Docker Hub:**
```sh
docker push dhigras/esa-snap
```

## Key Files

- [Dockerfile](Dockerfile) — installs SNAP from ESA's official installer, runs module updates, sets `gpt` as entrypoint. The update step uses a `killall java` hack to terminate the updater once it prints `updates=0`.
- [s3tbx.properties](s3tbx.properties) — copied into `/usr/local/snap/etc/`; enables per-pixel geocoding for OLCI, MERIS, SLSTR readers.
- [snap.properties](snap.properties) — present in repo but currently commented out in the Dockerfile (`COPY` line is commented). Contains JAI tile cache/size tuning and GPF operator rename mappings.

## Upgrading SNAP

1. Find the new installer URL from `https://download.esa.int/step/snap/`
2. Update the `wget` URL and filename in the Dockerfile
3. Update the branch name to match the new version
