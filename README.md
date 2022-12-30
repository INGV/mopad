[![License](https://img.shields.io/github/license/INGV/mopad.svg)](https://github.com/INGV/mopad/blob/main/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/INGV/mopad.svg)](https://github.com/INGV/mopad/issues)

[![Docker build](https://img.shields.io/badge/docker%20build-from%20CI-yellow)](https://hub.docker.com/r/ingv/mopad)
![Docker Image Size (latest semver)](https://img.shields.io/docker/image-size/ingv/mopad?sort=semver)
![Docker Pulls](https://img.shields.io/docker/pulls/ingv/mopad)

[![CI](https://github.com/INGV/mopad/actions/workflows/docker-image.yml/badge.svg)](https://github.com/INGV/mopad/actions)
[![GitHub](https://img.shields.io/static/v1?label=GitHub&message=Link%20to%20repository&color=blueviolet)](https://github.com/INGV/mopad)

# MoPaD - Moment tensor Plotting and Decomposition 

Run MoPad within a docker.

MoPad is a tool for graphical and numerical analysis of seismic moment tensors

by Lars Krieger and Sebastian Heimann

http://www.larskrieger.de/mopad/

https://github.com/geophysics/MoPaD

## Quickstart
### Get Docker image
To obtain *mopad* docker image, you have two options:

#### 1) Get built image from DockerHub (*preferred*)
Get the last built image from DockerHub repository:
```sh
docker pull ingv/mopad:latest
```

#### 2) Build by yourself
Clone the git repositry:
```sh
git clone https://github.com/INGV/mopad.git
cd mopad
```
build the image:
```sh
docker build --tag ingv/mopad . 
```

in case of errors, try:
```sh
docker build --no-cache --pull --tag ingv/mopad . 
```

### Run as service
Make a local *volume* (directory) for nginx cache:
```sh
mkdir /tmp/mopad_cache
```

run the container in daemon (`-d`) mode:
```sh
docker run -d --name mopad_container --rm -v /tmp/mopad_cache:/var/cache -p 8383:80 ingv/mopad
```

Then test access to http://localhost:8383/.

Examples of URL:

- http://localhost:8383/cgi-bin/mopad.cgi?plot_arg=0,55,23
- http://localhost:8383/cgi-bin/mopad.cgi?plot_arg=-40.568,-24.033,64.601,125.752,-90.024,-7.461&color=0,255,0
- http://localhost:8383/cgi-bin/mopad.cgi?plot_arg=-63.828,-8.743,72.571,19.328,-12.439,-9.573&color=blue

Reminder: mopad plot `mxx`,`myy`,`mzz`,`mxy`,`mxz`,`myz` ...

### Run without X11 display

```sh
docker run --rm -it ingv/mopad ...mopad-arguments...
```

### Run with X11 display

```sh
docker run --rm -it \
	-e DISPLAY=${MYIP}:0 \
	--mount type=bind,source=/tmp/.X11-unix,target=/tmp/.X11-unix \
	ingv/mopad \
	$@
```

### Run by Wrapper Script

```sh
./runMoPadInDocker.sh plot 0,1,-1,0,0,0
```

### Run by Pipe usage

##### Additonal argument "piped"

```
docker run --rm ingv/mopad piped ...mopad-arguments... -f "docker_outfilename" > "host_outfilename"
```

**N.B.: "docker_outfilename" must be the last argument.**

Examples:

```
docker run --rm  ingv/mopad piped plot 0,1,-1,0,0,0 -f tmp.svg > out.svg
```

```
docker run --rm  ingv/mopad piped plot 0,1,-1,0,0,0 -f tmp.png > out.png
```

##### Custom pipe usage

```
docker run --rm ingv/mopad "mopad plot 0,1,-1,0,0,0 -f tmp.png && cat tmp.png" > out.png
```

## Contribute
Thanks to your contributions!

Here is a list of users who already contributed to this repository: \
<a href="https://github.com/ingv/mopad/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=ingv/mopad" />
</a>

## Author
(c) 2022 Matteo Quintiliani matteo.quintiliani[at]ingv.it \
(c) 2022 Valentino Lauciani valentino.lauciani[at]ingv.it
