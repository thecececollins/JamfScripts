#!/bin/bash
if [[ ! $(whoami) = "root" ]];then echo "Must be root.";exit 1;fi
curUser="$(ls -l /dev/console | awk '{ print $3 }')"
numtest='^[0-9]+$'
arg=$3
if ! [[ -z $arg ]];then
  if [[ $arg =~ $numtest ]];then 
    sleeptimer=$arg
  else 
    sleeptimer=40
  fi
else 
  sleeptimer=40
fi
isUserAnAdmin () {
  if [[ $(dscl . read /Groups/admin GroupMembership | grep -oq "${curUser}";echo $?) -eq 0 ]];then
    true
  else
    false
  fi
}
grant_admin () {
  dscl . append /Groups/admin GroupMembership "${curUser}"
}
deny_admin () {
  dscl . delete /Groups/admin GroupMembership "${curUser}" >/dev/null 2>&1
}
exit_script () {
  if isUserAnAdmin;then
    deny_admin
  fi
}
if isUserAnAdmin;then
  exit
else
 grant_admin
 trap exit_script SIGINT SIGTERM
 sleep ${sleeptimer}
 deny_admin
fi
exit $?
