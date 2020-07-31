#!/usr/bin/expect

set localFile  "."
set remoteDir  "/home/tidb/tidb-ansible-v3.0.15-cdpmagic"
set remoteIp   "172.28.30.28"
set remotePort "11822"
set remoteUser "tidb"
set remotePwd  "hwsqj110"

set timeout 3600

exec sh -c {echo "" > ./rsync.log}

spawn rsync -arqPz --log-file "./rsync.log" --exclude ".idea" --exclude "*.vswp" --exclude "*.swp" --exclude "*.DS_Store" -e "ssh -l$remoteUser -p$remotePort" $localFile $remoteIp:$remoteDir

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
