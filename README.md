# Bunny
Bunny application stack

# Setup
In order to use this repository, build and run bunny platform, you need to download and install Docker and Docker Compose:

Install docker for your platform
```
https://docs.docker.com/installation/#installation
```

for Mac it is [HERE](http://docs.docker.com/engine/installation/mac/)

~~Install compose for your platform~~~
edit: docker compose is now part of docker-machine

Fetch the submodules
```
git submodule init && git submodule update
```

# Building

First time run
```
docker-compose up
```

If you make changes to a repo and want to test them you must run
```
docker-compose rm
docker-compose build
docker-compose up
```

# DB Setup

```
docker-compose run bunny rake db:migrate
docker-compose run galleryservice rake db:migrate
```

# FAQ
## What is the IP address (MAC)
```
docker-machine ip
```

# Git submodule command
```git submodule foreach 'echo $path `git rev-parse HEAD`'```
```git submodule foreach 'git checkout master'```


# Useful commands

Getting docker to work

```
eval $(docker-machine env default)
```

File upload
```
curl -i -F avatar=@highchair_rukabunny_smallres.jpg http://dev.bunny.int/images
```

