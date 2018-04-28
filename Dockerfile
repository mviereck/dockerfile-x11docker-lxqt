# x11docker/lxqt
# 
# Run LXQT desktop in docker. 
# Use x11docker to run image. 
# Get x11docker from github: 
#   https://github.com/mviereck/x11docker 
#
# Examples: x11docker --desktop x11docker/lxqt
#           x11docker x11docker/lxqt pcmanfm-qt

FROM debian:stretch
ENV DEBIAN_FRONTEND noninteractive
 
RUN apt-get  update
RUN apt-get install -y dbus-x11 procps psmisc

# OpenGL / MESA
RUN apt-get install -y mesa-utils mesa-utils-extra libxv1 kmod xz-utils

# Language/locale settings
# replace en_US by your desired locale setting, 
# for example de_DE for german.
ENV LANG en_US.UTF-8
RUN echo $LANG UTF-8 > /etc/locale.gen
RUN apt-get install -y locales && update-locale --reset LANG=$LANG

# some utils to have proper menus, mime file types etc.
RUN apt-get install -y --no-install-recommends xdg-utils xdg-user-dirs \
    menu menu-xdg mime-support desktop-file-utils

# LXQT desktop
RUN apt-get install -y --no-install-recommends lxqt-core
RUN apt-get install -y --no-install-recommends qterminal lxqt-config \
    lxqt-notificationd lxqt-about lxqt-qtplugin lxqt-runner juffed
RUN apt-get install -y qtwayland5

# config lxqt
RUN mkdir -p /etc/skel/.config/lxqt
RUN echo '[General]\n\
__userfile__=true\n\
icon_theme=gnome\n\
single_click_activate=false\n\
theme=ambiance\n\
tool_button_style=ToolButtonTextBesideIcon\n\
\n\
[Qt]\n\
doubleClickInterval=400\n\
font="Sans,11,-1,5,50,0,0,0,0,0"\n\
style=Fusion\n\
wheelScrollLines=3\n\
' >/etc/skel/.config/lxqt/lxqt.conf

# config pcmanfm-qt
RUN mkdir -p /etc/skel/.config/pcmanfm-qt/lxqt
RUN echo '[Desktop]\n\
ShowHidden=true\n\
Wallpaper=/usr/share/lxqt/themes/ambiance/Butterfly-Kenneth-Wimer.jpg\n\
WallpaperMode=stretch\n\
' >/etc/skel/.config/pcmanfm-qt/lxqt/settings.conf

# config panel / add some launchers
RUN echo '[quicklaunch]\n\
alignment=Left\n\
apps\\1\desktop=/usr/share/applications/pcmanfm-qt.desktop\n\
apps\\2\desktop=/usr/share/applications/qterminal.desktop\n\
apps\\3\desktop=/usr/share/applications/juffed.desktop\n\
apps\size=3\n\
type=quicklaunch\n\
' >> /etc/xdg/lxqt/panel.conf

# startscript to copy dotfiles from /etc/skel
# runs either CMD or image command from docker run
RUN echo '#! /bin/sh\n\
[ -n "$HOME" ] && [ ! -e "$HOME/.config" ] && cp -R /etc/skel/. $HOME/ \n\
exec $* \n\
' > /usr/local/bin/start 
RUN chmod +x /usr/local/bin/start 

ENTRYPOINT ["/usr/local/bin/start"]
CMD ["startlxqt"]


ENV DEBIAN_FRONTEND newt
