echo "Starting setup..."

echo "Going to log directory"
cd /var/log

echo "Setting editor to Vim"
export EDITOR=vim

echo "Configuring aliases"
alias l="ls"
alias cls="clear"
alias myip="curl ifconfig.me"

echo "Setting up vim"
mkdir ~/.vim
curl -s "https://raw.githubusercontent.com/ruan-xian/linux-configs/refs/heads/main/iceberg.vim" > ~/.vim/iceberg.vim

echo "Done!"
