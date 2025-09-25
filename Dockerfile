ARG image
FROM ${image} AS builder

ENV DEBIAN_FRONTEND=noninteractive
# Install system dependencies that the Boost libraries need
RUN \
  apt-get update && \
  apt-get upgrade -y -qq && \
  apt-get install -y -qq \
    build-essential \
    libbz2-dev \
    libicu-dev \
    liblzma-dev \
    libssl-dev \
    python3-dev \
    zlib1g-dev

FROM builder
# Add the Boost tarball
ARG workdir
WORKDIR ${workdir}
COPY ${workdir} .

# Now build it
RUN \
  g++ --version && \
  ./bootstrap.sh --show-libraries && \
  ./bootstrap.sh --prefix=/usr/local && \
  ./b2 && \
  ./b2 install
