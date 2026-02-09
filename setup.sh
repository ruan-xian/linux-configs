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
alias lm="less /var/log/messages"

echo "Setting up vim colors"
curl --create-dirs -so ~/.vim/colors/iceberg.vim "https://raw.githubusercontent.com/cocopon/iceberg.vim/refs/heads/master/colors/iceberg.vim"

echo "Setting up .vimrc"
curl -so ~/.vimrc "https://raw.githubusercontent.com/ruan-xian/linux-configs/refs/heads/main/.vimrc"

echo "Setting up functions"
,count5xx() {
    { echo "5xx Count    ,Route"; awk '/5[0-9]{2}\s+[0-9]+\s+[0-9]+ms/ {gsub(/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/, ".*", $(NF-3)); gsub(/[0-9a-f]{24}/, ".*", $(NF-3)); c[sprintf("%-8s%s", $(NF-4), $(NF-3))]++} END {for (k in c) print c[k] "," k}' /var/log/messages | sort -rn; } | column -t -s ","
    }
,get5xxContext() {
    grep -B 10 --color=always "$1 500" /var/log/messages | less -R
}
,runtimes() {
    { echo "Reqs,Route,Avg,Med,P90,OK%"; gawk '
/[0-9]{3}\s+\S+\s+[0-9]+ms/ {
    route = $(NF-3); method = $(NF-4); status = $(NF-2); time = $(NF)
    gsub(/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/, ".*", route)
    gsub(/[0-9a-f]{24}/, ".*", route)
    gsub(/\.\*\.[0-9]+/, ".*", route)
    gsub(/\/ticker\/[A-Za-z0-9.]+/, "/ticker/.*", route)
    gsub(/\?.*/, "", route)
    key = method " " route
    sub(/ms$/, "", time); time = time + 0
    times[key][++n[key]] = time
    if (status + 0 < 500) ok[key]++
}
END {
    red = "\033[31m"; yellow = "\033[33m"; reset = "\033[0m"
    for (key in n) {
        cnt = n[key]
        asort(times[key])
        sum = 0
        for (i = 1; i <= cnt; i++) sum += times[key][i]
        avg = int(sum / cnt + 0.5)
        med_i = int((cnt + 1) / 2)
        if (cnt % 2 == 1) med = times[key][med_i]
        else med = int((times[key][cnt/2] + times[key][cnt/2+1]) / 2 + 0.5)
        p90_i = int(cnt * 0.9 + 0.5)
        if (p90_i < 1) p90_i = 1
        if (p90_i > cnt) p90_i = cnt
        p90 = times[key][p90_i]
        ok_pct = (ok[key] + 0) / cnt * 100
        color = ""
        if (ok_pct < 100) color = red
        else if (avg >= 1000) color = red
        else if (avg >= 500) color = yellow
        printf "%s%d,%s,%dms,%dms,%dms,%.1f%%%s\n", color, cnt, key, avg, med, p90, ok_pct, (color ? reset : "")
    }
}' /var/log/messages | sort -t, -k3 -rn; } | column -t -s "," | less -RFS
}

echo "Done!"
