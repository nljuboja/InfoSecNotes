sudo apt update -y

sudo apt install -y vim exuberant-ctags cscope tmux net-tools git python cmake build-essential gitk qttools5-dev-tools make

mkdir ~/bin
cd ~/bin
git clone https://github.com/radareorg/radare2
cd radare2 ; sys/install.sh

cd ..
wget https://github.com/radareorg/r2cutter/releases/download/v1.12.0/Cutter-v1.12.0-x64.Linux.AppImage

r2pm init
r2pm update
r2pm -ci r2ghidra
