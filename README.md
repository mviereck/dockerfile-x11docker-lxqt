# x11docker/lxqt

Base image LXQT desktop (on debian stretch)
 - Run LXQT desktop in docker.
 - Use x11docker to to run GUI applications and desktop environments in docker images.
 - Get [x11docker from github](https://github.com/mviereck/x11docker)

# Example commands: 
 - Single application: `x11docker x11docker/lxqt pcmanfm-qt`
 - Full desktop: `x11docker --desktop x11docker/lxqt` 
 
# Extend base image
To add your desired applications, create your own Dockerfile `mydockerfile` with this image as a base. Example:
```
FROM x11docker/lxqt
RUN apt-get update
RUN apt-get install -y firefox
```
Build an image with `docker build -t mylxqt - < mydockerfile`. Run desktop with `x11docker --desktop mylxqt` or firefox only with `x11docker mylxqt firefox`.

# Screenshot
 LXQT desktop in an Xnest window running with x11docker:
 
 ![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-lxqt.png "LXQT desktop running in Xnest window using x11docker")
 

