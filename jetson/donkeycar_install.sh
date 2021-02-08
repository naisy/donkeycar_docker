#!/bin/bash -e

password='jetson'
# Get the full dir name of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Keep updating the existing sudo time stamp
sudo -v
while true; do sudo -n true; sleep 120; kill -0 "$$" || exit; done 2>/dev/null &

########################################
# Install DonkeyCar
########################################
sudo apt-get update -y
sudo apt-get upgrade -y

# Vertual Env
pip3 install virtualenv
python3 -m virtualenv -p python3 ~/.virtualenv/donkeycar --system-site-packages
echo "source ~/.virtualenv/donkeycar/bin/activate" >> ~/.bashrc
# "source ~/.virtualenv/donkeycar/bin/activate" in the shell script
. ~/.virtualenv/donkeycar/bin/activate


# Install DonkeyCar as user package
mkdir -p ~/projects; cd ~/projects
cd ~/projects
git clone https://github.com/autorope/donkeycar
cd donkeycar
git checkout dev
pip install -e .[nano]

# https://github.com/keras-team/keras-tuner/issues/317
echo "export LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libgomp.so.1" >> ~/.bashrc
#export LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libgomp.so.1

