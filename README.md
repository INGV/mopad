# MoPad in Docker

Run MoPad within a docker

## MoPaD -- Moment tensor Plotting and Decomposition

A tool for graphical and numerical analysis of seismic moment tensors

by Lars Krieger and Sebastian Heimann

http://www.larskrieger.de/mopad/

https://github.com/geophysics/MoPaD

### Build

```
docker-compose build
```

### Run as service

```sh
docker-compose up -d
```

Then test access to http://localhost:8383/.

Examples of URL:

- http://localhost:8383/cgi-bin/mopad.cgi?plot_arg=0,55,23
- http://localhost:8383/cgi-bin/mopad.cgi?plot_arg=-40.568,-24.033,64.601,125.752,-90.024,-7.461&color=0,255,0
- http://localhost:8383/cgi-bin/mopad.cgi?plot_arg=-63.828,-8.743,72.571,19.328,-12.439,-9.573&color=blue

Reminder: mopad plot ${mxx},${myy},${mzz},${mxy},${mxz},${myz} ...

### Run without X11 display

```sh
docker run --rm -it mopad_site ...mopad-arguments...
```

### Run with X11 display

```sh
docker run --rm -it \
	-e DISPLAY=${MYIP}:0 \
	--mount type=bind,source=/tmp/.X11-unix,target=/tmp/.X11-unix \
	mopad_site \
	$@
```

### Run by Wrapper Script

```sh
./runMoPadInDocker.sh plot 0,1,-1,0,0,0
```

### Run by Pipe usage

##### Additonal argument "piped"

```
docker run --rm mopad_site piped ...mopad-arguments... -f "docker_outfilename" > "host_outfilename"
```

**N.B.: "docker_outfilename" must be the last argument.**

Examples:

```
docker run --rm  mopad_site piped plot 0,1,-1,0,0,0 -f tmp.svg > out.svg
```

```
docker run --rm  mopad_site piped plot 0,1,-1,0,0,0 -f tmp.png > out.png
```

##### Custom pipe usage

```
docker run --rm mopad_site "mopad plot 0,1,-1,0,0,0 -f tmp.png && cat tmp.png" > out.png
```

