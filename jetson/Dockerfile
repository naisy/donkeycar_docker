########################################
# Docker build
########################################
#time sudo docker build -t donkeycar-jp45 -f Dockerfile .

# end of information


########################################
# Underlying OS repogitory
########################################
# container list
# https://ngc.nvidia.com/catalog/all?orderBy=modifiedDESC&query=l4t&quickFilter=&filters=
#r32.5.0 - JetPack 4.5
FROM nvcr.io/nvidia/l4t-ml:r32.5.0-py3


########################################
# ENV
########################################
ARG DEBIAN_FRONTEND=noninteractive


########################################
# apt fix
########################################
# Because somethime the repository is 404, use with --fix-missing option.
RUN rm -rf /var/lib/apt/lists/* \
&& apt-get --fix-missing update \
&& apt-get install -y apt-utils \
&& rm -rf /var/lib/apt/lists/*


########################################
# add gpio group for spi devices
########################################
# Add gpio group
# change i2c group id to 108 (the same as jetson nano jetpack 4.5)
RUN groupadd -f -r gpio
RUN groupmod -g 108 i2c


########################################
# XAuthority
########################################
RUN apt-get update && apt-get install -y sudo xauth xterm
#Add new sudo user
ARG USERNAME=jetson
RUN useradd -m $USERNAME && \
        echo "$USERNAME:$USERNAME" | chpasswd && \
        usermod --shell /bin/bash $USERNAME && \
        usermod -aG sudo,adm,cdrom,audio,dip,video,plugdev,i2c,gpio $USERNAME && \
        echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
        chmod 0440 /etc/sudoers.d/$USERNAME && \
        # Replace 1000 with your user/group id
        usermod  --uid 1000 $USERNAME && \
        groupmod --gid 1000 $USERNAME


########################################
# bash setting
########################################
# sed
# escape characters \'$.*/[]^
# 1. Write the regex between single quotes.
# 2. \ -> \\
# 3. ' -> '\''
# 4. Put a backslash before $.*/[]^ and only those characters.


####################
# USER
####################
# before
# #force_color_prompt=yes
# after
# force_color_prompt=yes

# before
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# after
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@docker\[\033[01;31m\]\h\[\033[00m\]:\[\033[01;35m\]\w\[\033[00m\]\$ '

# before
# alias ls='ls --color=auto'
# after
# alias ls='ls -asiF --color=auto'

RUN sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' /home/$USERNAME/.bashrc \
&& sed -i 's/PS1='\''\${debian_chroot:+(\$debian_chroot)}\\\[\\033\[01;32m\\\]\\u@\\h\\\[\\033\[00m\\\]:\\\[\\033\[01;34m\\\]\\w\\\[\\033\[00m\\\]\\\$ '\''/PS1='\''\${debian_chroot:+(\$debian_chroot)}\\\[\\033\[01;32m\\\]\\u@\\\[\\033\[01;31m\\\]docker\\\[\\033\[00m\\\]:\\\[\\033\[01;35m\\\]\\w\\\[\\033\[00m\\\]\\\$ '\''/g' /home/$USERNAME/.bashrc \
&& sed -i 's/alias ls='\''ls --color=auto'\''/alias ls='\''ls -asiF --color=auto'\''/g' /home/$USERNAME/.bashrc \
&& echo 'alias xterm='"'"'xterm -fa '"'"'Monospace'"'"' -fs 10'"'"'\n' >> /home/$USERNAME/.bashrc \
&& echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/lib' >> /home/$USERNAME/.bashrc \
&& echo 'export LANG=en_US.UTF-8' >> /home/$USERNAME/.bashrc \
&& echo 'export NO_AT_BRIDGE=1' >> /home/$USERNAME/.bashrc \
&& echo 'cd' >> /home/$USERNAME/.bashrc \
&& echo "complete -d cd" >> /home/$USERNAME/.bashrc

####################
# ROOT
####################
# before
#    xterm-color) color_prompt=yes;;
# after
#    xterm-color|*-256color) color_prompt=yes;;

# before
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# after
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;37m\]\u@docker\[\033[01;31m\]\h\[\033[00m\]:\[\033[01;35m\]\w\[\033[00m\]\$ '

# before
# alias ls='ls --color=auto'
# after
# alias ls='ls -asiF --color=auto'

RUN sed -i 's/xterm-color) color_prompt=yes;;/xterm-color|\*-256color) color_prompt=yes;;/g' /root/.bashrc \
&& sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/g' /root/.bashrc \
&& sed -i 's/PS1='\''\${debian_chroot:+(\$debian_chroot)}\\\[\\033\[01;32m\\\]\\u@\\h\\\[\\033\[00m\\\]:\\\[\\033\[01;34m\\\]\\w\\\[\\033\[00m\\\]\\\$ '\''/PS1='\''\${debian_chroot:+(\$debian_chroot)}\\\[\\033\[01;37m\\\]\\u@\\\[\\033\[01;31m\\\]docker\\\[\\033\[00m\\\]:\\\[\\033\[01;35m\\\]\\w\\\[\\033\[00m\\\]\\\$ '\''/g' /root/.bashrc \
&& sed -i 's/alias ls='\''ls --color=auto'\''/alias ls='\''ls -asiF --color=auto'\''/g' /root/.bashrc \
&& echo 'alias xterm='"'"'xterm -fa '"'"'Monospace'"'"' -fs 10'"'"'\n' >> /root/.bashrc \
&& echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/lib' >> /root/.bashrc \
&& echo 'export LANG=en_US.UTF-8' >> /root/.bashrc \
&& echo 'export NO_AT_BRIDGE=1' >> /root/.bashrc \
&& echo "complete -d cd" >> /root/.bashrc


#########################################
# .dircolors
########################################
# end of line: \n\
# ': '"'"'

RUN echo '# dircolors -p > ~/.dircolors\n\
# vi ~/.dircolors\n\
# man dircolors\n\
\n\
# Configuration file for dircolors, a utility to help you set the\n\
# LS_COLORS environment variable used by GNU ls with the --color option.\n\
# Copyright (C) 1996-2016 Free Software Foundation, Inc.\n\
# Copying and distribution of this file, with or without modification,\n\
# are permitted provided the copyright notice and this notice are preserved.\n\
# The keywords COLOR, OPTIONS, and EIGHTBIT (honored by the\n\
# slackware version of dircolors) are recognized but ignored.\n\
# Below are TERM entries, which can be a glob patterns, to match\n\
# against the TERM environment variable to determine if it is colorizable.\n\
TERM Eterm\n\
TERM ansi\n\
TERM color-xterm\n\
TERM con[0-9]*x[0-9]*\n\
TERM cons25\n\
TERM console\n\
TERM cygwin\n\
TERM dtterm\n\
TERM eterm-color\n\
TERM gnome\n\
TERM gnome-256color\n\
TERM hurd\n\
TERM jfbterm\n\
TERM konsole\n\
TERM kterm\n\
TERM linux\n\
TERM linux-c\n\
TERM mach-color\n\
TERM mach-gnu-color\n\
TERM mlterm\n\
TERM putty\n\
TERM putty-256color\n\
TERM rxvt*\n\
TERM screen*\n\
TERM st\n\
TERM st-256color\n\
TERM terminator\n\
TERM tmux*\n\
TERM vt100\n\
TERM xterm*\n\
# Below are the color init strings for the basic file types. A color init\n\
# string consists of one or more of the following numeric codes:\n\
# Attribute codes:\n\
# 00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed\n\
# Text color codes:\n\
# 30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white\n\
# Background color codes:\n\
# 40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white\n\
#NORMAL 00 # no color code at all\n\
#FILE 00 # regular file: use no color at all\n\
RESET 0 # reset to "normal" color\n\
DIR 01;35 # directory\n\
LINK 01;36 # symbolic link. (If you set this to '"'"'target'"'"' instead of a\n\
 # numerical value, the color is as for the file pointed to.)\n\
MULTIHARDLINK 00 # regular file with more than one link\n\
FIFO 40;99 # pipe\n\
SOCK 01;32 # socket\n\
DOOR 01;32 # door\n\
BLK 40;99;01 # block device driver\n\
CHR 40;99;01 # character device driver\n\
ORPHAN 40;31;01 # symlink to nonexistent file, or non-stat'"'"'able file ...\n\
MISSING 00 # ... and the files they point to\n\
SETUID 37;41 # file that is setuid (u+s)\n\
SETGID 30;43 # file that is setgid (g+s)\n\
CAPABILITY 30;41 # file with capability\n\
STICKY_OTHER_WRITABLE 30;42 # dir that is sticky and other-writable (+t,o+w)\n\
OTHER_WRITABLE 35;42 # dir that is other-writable (o+w) and not sticky\n\
STICKY 37;44 # dir with the sticky bit set (+t) and not other-writable\n\
# This is for files with execute permission:\n\
EXEC 01;31\n\
# List any file extensions like '"'"'.gz'"'"' or '"'"'.tar'"'"' that you would like ls\n\
# to colorize below. Put the extension, a space, and the color init string.\n\
# (and any comments you want to add after a '"'"'#'"'"')\n\
# If you use DOS-style suffixes, you may want to uncomment the following:\n\
#.cmd 01;31 # executables (bright green)\n\
#.exe 01;31\n\
#.com 01;31\n\
#.btm 01;31\n\
#.bat 01;31\n\
# Or if you want to colorize scripts even if they do not have the\n\
# executable bit actually set.\n\
#.sh 01;31\n\
#.csh 01;31\n\
 # archives or compressed (bright red)\n\
.tar 01;33\n\
.tgz 01;33\n\
.arc 01;33\n\
.arj 01;33\n\
.taz 01;33\n\
.lha 01;33\n\
.lz4 01;33\n\
.lzh 01;33\n\
.lzma 01;33\n\
.tlz 01;33\n\
.txz 01;33\n\
.tzo 01;33\n\
.t7z 01;33\n\
.zip 01;33\n\
.z 01;33\n\
.Z 01;33\n\
.dz 01;33\n\
.gz 01;33\n\
.lrz 01;33\n\
.lz 01;33\n\
.lzo 01;33\n\
.xz 01;33\n\
.bz2 01;33\n\
.bz 01;33\n\
.tbz 01;33\n\
.tbz2 01;33\n\
.tz 01;33\n\
.deb 01;33\n\
.rpm 01;33\n\
.jar 01;33\n\
.war 01;33\n\
.ear 01;33\n\
.sar 01;33\n\
.rar 01;33\n\
.alz 01;33\n\
.ace 01;33\n\
.zoo 01;33\n\
.cpio 01;33\n\
.7z 01;33\n\
.rz 01;33\n\
.cab 01;33\n\
# image formats\n\
.jpg 01;32\n\
.jpeg 01;32\n\
.gif 01;32\n\
.bmp 01;32\n\
.pbm 01;32\n\
.pgm 01;32\n\
.ppm 01;32\n\
.tga 01;32\n\
.xbm 01;32\n\
.xpm 01;32\n\
.tif 01;32\n\
.tiff 01;32\n\
.png 01;32\n\
.svg 01;32\n\
.svgz 01;32\n\
.mng 01;32\n\
.pcx 01;32\n\
.mov 01;32\n\
.mpg 01;32\n\
.mpeg 01;32\n\
.m2v 01;32\n\
.mkv 01;32\n\
.webm 01;32\n\
.ogm 01;32\n\
.mp4 01;32\n\
.m4v 01;32\n\
.mp4v 01;32\n\
.vob 01;32\n\
.qt 01;32\n\
.nuv 01;32\n\
.wmv 01;32\n\
.asf 01;32\n\
.rm 01;32\n\
.rmvb 01;32\n\
.flc 01;32\n\
.avi 01;32\n\
.fli 01;32\n\
.flv 01;32\n\
.gl 01;32\n\
.dl 01;32\n\
.xcf 01;32\n\
.xwd 01;32\n\
.yuv 01;32\n\
.cgm 01;32\n\
.emf 01;32\n\
# http://wiki.xiph.org/index.php/MIME_Types_and_File_Extensions\n\
.axv 01;32\n\
.anx 01;32\n\
.ogv 01;32\n\
.ogx 01;32\n\
# audio formats\n\
.aac 00;36\n\
.au 00;36\n\
.flac 00;36\n\
.m4a 00;36\n\
.mid 00;36\n\
.midi 00;36\n\
.mka 00;36\n\
.mp3 00;36\n\
.mpc 00;36\n\
.ogg 00;36\n\
.ra 00;36\n\
.wav 00;36\n\
# http://wiki.xiph.org/index.php/MIME_Types_and_File_Extensions\n\
.axa 00;36\n\
.oga 00;36\n\
.opus 00;36\n\
.spx 00;36\n\
.xspf 00;36\n'\
> /root/.dircolors && cp /root/.dircolors /home/$USERNAME/.dircolors && chown $USERNAME:$USERNAME /home/$USERNAME/.dircolors


########################################
# Default Command
########################################
#CMD bash -c "/usr/bin/xterm -fa 'Monospace' -fs 10"
CMD bash -c "/bin/bash"


### END GUI ###


########################################
# Packages
########################################
RUN apt-get -y install vim less htop unzip locate git curl wget arp-scan

