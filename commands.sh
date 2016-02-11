#!/bin/bash

# read in variables
read nick chan saying

# function for replying
function say { echo "PRIVMSG $1 :$2" ; }

# function for parsing
function has { $(echo "$1" | grep -P "$2" > /dev/null) ; }

# scan for keywords
if has "$saying" "!Away" ; then
        say $chan "$nick: You are now set to Away."
        sed -i "/ $nick /d" users.txt
        echo " $nick is Away. Last change was `date`." >> users.txt
fi

if has "$saying" "!away" ; then
        say $chan "$nick: You are now set to Away."
        sed -i "/ $nick /d" users.txt
        echo " $nick is Away. Last change was `date`." >> users.txt
fi

if has "$saying" "!Online" ; then
        say $chan "$nick: You are now set to Online."
        sed -i "/ $nick /d" users.txt
        echo " $nick is Online. Last change was `date`." >> users.txt
fi

if has "$saying" "!online" ; then
        say $chan "$nick: You are now set to Online."
        sed -i "/ $nick /d" users.txt
        echo " $nick is Online. Last change was `date`." >> users.txt
fi

if has "$saying" "!Busy" ; then
        say $chan "$nick: You are now set to Busy."
        sed -i "/ $nick /d" users.txt
        echo " $nick is Busy. Last change was `date`." >> users.txt
fi

if has "$saying" "!busy" ; then
        say $chan "$nick: You are now set to Busy."
        sed -i "/ $nick /d" users.txt
        echo " $nick is Busy. Last change was `date`." >> users.txt
fi

if has "$saying" "StatusBot:" ; then
        if has "$saying" "StatusBot: help" ; then
                say $chan "$nick: Type \"!away\" to set yourself to Away."
                say $chan "$nick: Type \"!online\" to set yourself to Online."
                say $chan "$nick: Type \"!busy\" to set yourself to Busy."
                say $chan "$nick: Type \"StatusBot: <user>\" to look up the status of a specific user."
        elif has "$saying" "StatusBot: Help" ; then
                say $chan "$nick: Type \"!away\" to set yourself to Away."
                say $chan "$nick: Type \"!online\" to set yourself to Online."
                say $chan "$nick: Type \"!busy\" to set yourself to Busy."
                say $chan "$nick: Type \"StatusBot: <user>\" to look up the status of a specific user."
        elif has "$saying" "StatusBot: Source" ; then
                say $chan "Synt4x is my creator. I do not currently have public source code."
        elif has "$saying" "StatusBot: source" ; then
                say $chan "Synt4x is my creator. I do not currently have public source code."
        else
                search="$(echo $saying | cut -f 2 -d ' ')"
                if grep -i " $search " users.txt ; then
                          replace="$(grep -i " $search " users.txt)"
                          sed -i "1s/.*/$replace/" command.txt
                          line="$(head -n 1 command.txt)"
                          say $chan "User$line"
                          echo "WHOIS $search $search"
                else
                          echo "WHOIS $search $search"
                fi

        fi
fi
