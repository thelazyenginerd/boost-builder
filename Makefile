## Boost
boost_version = 1.89.0
boost_workdir = boost_1_89_0
boost_tarball = ${boost_workdir}.tar.bz2
boost_remote_url = https://archives.boost.io/release/${boost_version}/source/${boost_tarball}

## Builder
image ?= ubuntu:noble

all: build
clean:
	rm -rf ${boost_workdir} ${boost_tarball}
	podman rmi -f builder
	podman rmi -f boost

${boost_tarball}:
	wget --quiet ${boost_remote_url} --output-document $@

${boost_workdir}: ${boost_tarball}
	tar jxf ${boost_tarball}

build: ${boost_workdir}
	podman build \
		--target builder \
		--tag builder \
		--build-arg image=${image} \
		--build-arg workdir=${boost_workdir} \
		--rm .
	podman build \
		--tag boost \
		--build-arg image=${image} \
		--build-arg workdir=${boost_workdir} \
		--rm .
	podman images
