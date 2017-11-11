# x11docker/lxqt

Base image LXQT desktop (on debian stretch)
 - Run LXQT desktop in docker.
 - Use x11docker to run image to run GUI applications and desktop environments in docker images.
 - Get [x11docker from github](https://github.com/mviereck/x11docker)

# Example commands: 
 - Single application: `x11docker x11docker/lxqt pcmanfm-qt`
 - Full desktop: `x11docker --desktop x11docker/lxqt` 
 
 # Screenshot
 LXQT desktop in an Xnest window running with x11docker:
 
 ![screenshot](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-lxqt.png "LXQT desktop running in Xnest window using x11docker")
 

