#!/usr/bin/env bash

# Need a connection to the IRC server, and be parsing
# what is happening in the window.

# say function also used in commands.sh
function say { echo "PRIVMSG $1 :$2" ; }

key=`cat $1`
function send {
        echo "-> $1"
        echo "$1" >> .botfile
}

# Create a fresh run file
rm whois.txt
rm .botfile
mkfifo .botfile

# Establish/maintain connection to the server
tail -f .botfile | openssl s_client -connect irc.cat.pdx.edu:6697 | while true
        if [[ -z $started ]] ; then
                send "NICK StatusBot"
                send "USER 0 0 0 :SYNT4XBOT"
                send "JOIN #robots $key"
                send "JOIN #necromancers $key"
                send "JOIN #zombies $key"
                send "JOIN #hack $key"
                send "JOIN # $key"
                send "JOIN #wintel $key"
                send "JOIN #mtg"
                send "JOIN #envytest"
                started="yes"
        fi
        read irc
        echo "<- $irc" | tee last_input.txt
        if `echo $irc | cut -d ' ' -f 1 | grep PING > /dev/null` ; then
                send "PONG"
        elif `echo $irc | grep PRIVMSG > /dev/null` ; then
                echo $irc > last_message.txt
                chan=`echo $irc | cut -d ' ' -f 3`
                identity=`echo $irc | cut -d ' ' -f 1-3`
                saying=`echo ${irc##$identity :}|tr -d "\r\n"`
                nick="${irc%%!*}"; nick="${nick#:}"
                var=`echo $nick $chan $saying | ./commands.sh`
                search="$(echo $saying | cut -f 2 -d ' ')"
                if [[ ! -z $var ]] ; then
                        send "$var"
                fi
        else
                echo $irc >> whois.txt
                chan=`cat last_message.txt | cut -d ' ' -f 3`
                if grep "End of /WHOIS list." whois.txt > /dev/null ; then
                        if grep "No such server" whois.txt > /dev/null ; then
                                echo ".DOESNOTEXIST." > whois.txt
                        fi
                        if grep ".DOESNOTEXIST." whois.txt > /dev/null ; then
                                send "PRIVMSG $chan :User or command not recognized."
                        else
                                if grep "seconds idle, signon time" whois.txt > /dev/null ; then
                                        if [[ -z $idle ]] ; then
                                                grep "seconds idle, signon time" whois.txt | cut -d ' ' -f 5 > idle_seconds.txt
                                                ./timeConvert > idle_time.txt
                                                idle=`cat idle_time.txt`
                                        fi
                                fi
                                if grep $chan whois.txt > /dev/null ; then
                                        if [[ -z $inchan ]] ; then
                                            inchan="yes"
                                        fi
                                fi
                                if [[ ! -z $idle ]] ; then
                                        send "PRIVMSG $chan :Idle time for user is $idle"
                                        idle=
                                else
                                        send "PRIVMSG $chan :Idle time unavailable for user."
                                fi
                                if [[ ! -z $inchan ]] ; then
                                        send "PRIVMSG $chan :User is in the current channel."
                                        inchan=
                                else
                                        send "PRIVMSG $chan :User is not in the current channel."
                                fi
                        fi
                        > whois.txt
                fi
        fi
done
