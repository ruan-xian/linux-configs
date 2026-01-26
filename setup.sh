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
mkdir ~/.vim/colors
curl -s "https://raw.githubusercontent.com/cocopon/iceberg.vim/refs/heads/master/colors/iceberg.vim" > ~/.vim/colors/iceberg.vim

echo "Done!"
