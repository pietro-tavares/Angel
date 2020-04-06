#!/bin/bash
set -x

sudo apt -y update
sudo apt -y upgrade

# TODO: Pin exact versions
sudo apt -y install gcc \
                    llvm \
                    make \
                    build-essential \
                    libc6 \
                    gdb \
					gdb-multiarch \
					tmux \
					git \
					foremost \
					unzip \
					python3 \
					python3-pip \
					python3-dev \
					ipython \
					virtualenvwrapper \
					libssl-dev \
					libffi-dev \
					qemu \
					qemu-user \
					qemu-user-static \
					'binfmt*' \
					debian-keyring \
					debian-archive-keyring \
					emdebian-archive-keyring


sudo tee /etc/apt/sources.list << EOF
deb http://mirrors.mit.edu/debian buster main contrib
deb http://www.emdebian.org/debian buster main contrib
EOF

sudo apt -y update
sudo apt -y upgrade

sudo mkdir -p /etc/qemu-binfmt
sudo ln -s /usr/mipsel-linux-gnu /etc/qemu-binfmt/mipsel 
sudo ln -s /usr/arm-linux-gnueabihf /etc/qemu-binfmt/arm

# xfce4
sudo apt install xfce4 xfce4-goodies task-xfce-desktop

mkdir ~/tools
cd ~/tools

# Python3 is the default
export alias python='python3'
export alias pip='pip3'

# FZF
git clone --depth 1 https://github.com/junegunn/fzf.git ~/tools/fzf
yes | ~/tools/fzf/install

# Pwntools
python3 -m pip install --upgrade pip
python3 -m pip install --upgrade git+https://github.com/Gallopsled/pwntools.git@dev

# GEF
wget -q -O- https://github.com/hugsy/gef/raw/master/scripts/gef.sh | sh

# radare2
git clone https://github.com/radare/radare2
cd radare2
./sys/install.sh

# frida
sudo pip3 install frida-tools

# Capstone
git clone https://github.com/aquynh/capstone
cd capstone
git checkout -t origin/next
sudo ./make.sh install
cd bindings/python
sudo python3 setup.py install

# binwalk
cd 
git clone https://github.com/devttys0/binwalk
cd binwalk
sudo python3 setup.py install
sudo apt install squashfs-tools

# Firmware-Mod-Kit
sudo apt -y install git build-essential zlib1g-dev liblzma-dev python-magic
cd ~/tools
wget https://firmware-mod-kit.googlecode.com/files/fmk_099.tar.gz
tar xvf fmk_099.tar.gz
rm fmk_099.tar.gz
cd fmk_099/src
./configure
make

# Uninstall capstone
sudo pip2 uninstall capstone -y

# Install correct capstone
cd ~/tools/capstone/bindings/python
sudo python3 setup.py install

# Personal config
sudo sudo apt -y install stow
cd /home/vagrant
rm .bashrc
git clone https://github.com/pietro-tavares/dotfiles

# Install Angr
cd /home/vagrant
sudo apt -y install 
sudo pip3 install angr --upgrade

# Install american-fuzzy-lop
sudo apt -y install clang llvm
cd ~/tools
wget --quiet http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz
tar -xzvf afl-latest.tgz
rm afl-latest.tgz
(
  cd afl-*
  make
  # build clang-fast
  (
    cd llvm_mode
    make
  )
  sudo make install
)

# Install 32 bit libs
sudo dpkg --add-architecture i386
sudo apt update
sudo apt -y install libc6:i386 libncurses5:i386 libstdc++6:i386
sudo apt -y install libc6-dev-i386

# Install apktool - from https://github.com/zardus/ctf-tools
apt update
apt install -y default-jre
wget https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool
wget https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.0.2.jar
mv apktool_2.0.2.jar /bin/apktool.jar
mv apktool /bin/
chmod 755 /bin/apktool
chmod 755 /bin/apktool.jar

# Install preeny
git clone --depth 1 https://github.com/zardus/preeny
PATH=$PWD/../crosstool/bin:$PATH

cd preeny
for i in ../../crosstool/bin/*-gcc
do
    t=$(basename $i)
    CC=$t make -j $(nproc) -i
done
PLATFORM=-m32 setarch i686 make -i
mv x86_64-linux-gnu i686-linux-gnu
make -i

# Install Pillow
sudo apt build-dep python-imaging
sudo apt install libjpeg8 libjpeg62-dev libfreetype6 libfreetype6-dev
sudo pip3 install Pillow

# Install r2pipe
sudo pip3 install r2pipe

# Install angr-dev
cd ~/tools
git clone https://github.com/angr/angr-dev
cd angr-dev

# Install ROPGadget
git clone https://github.com/JonathanSalwan/ROPgadget
cd ROPgadget
sudo python3 setup.py install
