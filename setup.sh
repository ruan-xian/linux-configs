echo "Starting setup..."

echo "Setting colors"
export TERM=xterm-256color

echo "Going to log directory"
cd /var/log

echo "Setting editor to Vim"
export EDITOR=vim

echo "Configuring aliases"
alias l="ls"
alias cls="clear"
alias myip="curl ifconfig.me"

echo "Setting up vim colors"
curl --create-dirs -so ~/.vim/colors/iceberg.vim "https://raw.githubusercontent.com/cocopon/iceberg.vim/refs/heads/master/colors/iceberg.vim"

echo "Setting up .vimrc"
curl -so ~/.vimrc "https://raw.githubusercontent.com/ruan-xian/linux-configs/refs/heads/main/.vimrc"

echo "Done!"
