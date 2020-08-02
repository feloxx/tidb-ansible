#!/usr/bin/expect

set localFile  "."
set remoteDir  "$1"
set remoteIp   "$2"
set remotePort "$3"
set remoteUser "$4"
set remotePwd  "$5"

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
