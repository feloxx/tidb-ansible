#!/usr/bin/expect

set localFile  "."
set remoteDir  "~/tidb-ansible-v3.0.15-cdpmagic"
set remoteIp   "10.150.31.29"
set remotePort "22"
set remoteUser "zhujinlong191211"
set remotePwd  "Snj7jqIjPfae4V"

set timeout 3600

exec sh -c {echo "" > ./rsync.log}

spawn rsync -arqPz --log-file "./rsync.log" --exclude ".idea" --exclude "*.vswp" --exclude "*.swp" --exclude "*.git" --exclude "*.DS_Store" -e "ssh -l$remoteUser -p$remotePort" $localFile $remoteIp:$remoteDir

expect {
    "password:" {
        send "$remotePwd\r"
            exp_continue
    }
    "yes/no)?" {
        send "yes\r"
            exp_continue
    }
    timeout {
        close
            break
    }
    eof {
        exit 0
    }
}

exit
