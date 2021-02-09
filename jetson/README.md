# donkeycar_docker
base-image: nvidia:l4t-ml

checked:
*   recording

not checked:
*   training
*   autonomous driving

## Environment
*   Username jetson  
If you want to use different username, edit files as you like.
*   Jetson Nano 4GB JetPack 4.5 only  
If you want to use other environment (jetpack, base-image, hardware), you should check the "i2c" group id and match it. Of course, other group ids. (check group id of host os and edit dockerfile)

## Setup
*   Login Jetson (GUI login or ssh remote login)

*   git clone
```
mkdir ~/github
cd ~/github
git clone https://github.com/naisy/donkeycar_docker
```
*   Docker build  
```
cd ~/github/donkeycar_docker/jetson
sudo docker build -t donkeycar-jp45 -f Dockerfile .
```
*   Create container  
`~/data` will be created as a shared directory for docker container and jetson.  
```
sudo su
./run.sh
```
*   Donkeycar Install  
```
# on Jetson
cp donkeycar_install.sh ~/data/
cp myconfig.py ~/data/
```
```
# on Docker
cd ~/data
./donkeycar_install.sh
```
```
# on Docker
. ~/.virtualenv/donkeycar/bin/activate
donkey createcar --path=~/mycar
cd ~/mycar
cp ~/data/myconfig.py ./
```

*   reboot  
```
# on Jetson
sudo reboot
```

## Start donkeycar docker container
```
# on Jetson
sudo docker ps -a # check docker container id
sudo docker start CONTAINER_ID
sudo docker exec -it CONTAINER_ID /bin/bash # login docker container
```

## Manual drive
```
# on Docker
cd ~/mycar
python manage.py drive
```
After that, you can access the http\://xxx.xxx.xxx.xxx:8887 in your web browser and drive.


## Transfer X window application
If you want to use GUI application on docker container, do the following:
```
# on PC terminal
ssh -CY jetson@xxx.xxx.xxx.xxx

#(Jetson)
env | grep DISPLAY # check DISPLAY value
sudo docker ps -a # check docker container id
sudo docker start CONTAINER_ID
sudo docker exec -it CONTAINER_ID /bin/bash

#(docker)
export DISPLAY=localhost:10 # set DISPLAY value
xterm
```
The xterm application will appear on your PC screen.

