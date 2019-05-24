# go-docker-scratch

smallest golang docker image based on scratch. use [Buildkit](https://github.com/moby/buildkit).

## Installation

Clone a directory outside of your GOPATH because it is using [go modules](https://github.com/golang/go/wiki/Modules)

```
git clone https://github.com/purini-to/go-docker-scratch
cd go-docker-scratch
```

## Quick Start

```bash
DOCKER_BUILDKIT=1 docker build . -t purini-to/go-docker-scratch

docker images
# REPOSITORY                                                    TAG                 IMAGE ID            CREATED             SIZE
# purini-to/go-docker-scratch                                   latest              d236e2c9a7d1        13 minutes ago      3.49MB

docker run --rm -p 3000:3000 purini-to/go-docker-scratch
```

#### Go to [http://localhost:3000/](http://localhost:3000/)
#### Go to [http://localhost:3000/time?tz=America/Los_Angeles](http://localhost:3000/time?tz=America/Los_Angeles)
#### Go to [http://localhost:3000/api](http://localhost:3000/api)
