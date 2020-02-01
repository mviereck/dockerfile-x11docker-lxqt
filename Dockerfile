# x11docker/lxqt
# 
# Run LXQT desktop in docker. 
# Use x11docker to run image. 
# Get x11docker from github: 
#   https://github.com/mviereck/x11docker 
#
# Examples: x11docker --desktop x11docker/lxqt
#           x11docker x11docker/lxqt pcmanfm-qt
#
# Options:
# Persistent home folder stored on host with   --home
# Shared host file or folder with              --share PATH
# Hardware acceleration with option            --gpu
# Clipboard sharing with option                --clipboard
# ALSA sound support with option               --alsa
# Pulseaudio sound support with option         --pulseaudio
# Language setting with                        --lang [=$LANG]
# Printing over CUPS with                      --printer
# Webcam support with                          --webcam
#
# See x11docker --help for further options.

FROM debian:buster
ENV DEBIAN_FRONTEND noninteractive
 
RUN apt-get update && \
    apt-get install -y dbus-x11 procps psmisc && \
    apt-get install -y mesa-utils mesa-utils-extra libxv1 kmod xz-utils && \
    apt-get install -y --no-install-recommends xdg-utils xdg-user-dirs \
                       menu-xdg mime-support desktop-file-utils

# Language/locale settings
# replace en_US by your desired locale setting, 
# for example de_DE for german.
ENV LANG en_US.UTF-8
RUN echo $LANG UTF-8 > /etc/locale.gen && \
    apt-get install -y locales && \
    update-locale --reset LANG=$LANG

# LXQT desktop
RUN apt-get install -y --no-install-recommends \
        lxqt-core qtwayland5 xfwm4 && \
    apt-get install -y --no-install-recommends \
        featherpad lxqt-about lxqt-config lxqt-qtplugin \
        pavucontrol-qt qlipper qterminal

# config lxqt
RUN mkdir -p /etc/skel/.config/lxqt && \
    echo '[General]\n\
__userfile__=true\n\
icon_theme=Adwaita\n\
single_click_activate=false\n\
theme=ambiance\n\
tool_button_style=ToolButtonTextBesideIcon\n\
\n\
[Qt]\n\
doubleClickInterval=400\n\
font="Sans,11,-1,5,50,0,0,0,0,0"\n\
style=Fusion\n\
wheelScrollLines=3\n\
' >/etc/skel/.config/lxqt/lxqt.conf && \
    echo '[General]\n\
__userfile__=true\n\
[Environment]\n\
TERM=qterminal\n\
' >/etc/skel/.config/lxqt/session.conf

# config pcmanfm-qt
RUN mkdir -p /etc/skel/.config/pcmanfm-qt/lxqt && \
    echo '[Desktop]\n\
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

CMD ["startlxqt"]
