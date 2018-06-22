#!/usr/bin/env bash
#########################################################################
##
## skeleton.sh
##
## bash script skeleton/example. 
##
#########################################################################

# shellcheck disable=SC1091
source /usr/local/lib/brashlib || {
  echo 'ERROR sourcing /usr/local/lib/brashlib'
  exit 1
}

MY_CONF='/etc/skeleton/skeleton.conf'

# shellcheck disable=SC1090
source "$MY_CONF" || Emergency "Could not source conf file $MY_CONF"

## Example, if you need a dir in /var
[[ -d "$MY_VARDIR" ]] || mkdir -p "$MY_VARDIR" ||
  Emergency "Could not create $MY_VARDIR"

## brashlib does 'set -e' as a failsafe.
## However, if you're avidly error-checking just about everything and using 
## something like zabbix_sender, it's better to unset it with 'set +e'.
## set +e

## Function Usage()
##
## Modify as needed
Usage () {
  echo "$(shortname $0) CMD TYPE"
  echo "  CMD = info | list"
  echo "  TYPE = foo | bar"
  exit 1
}

## Modify for number of options
(( $# != 2 )) && Usage

## Function CleanUp()
##
## Normally called via exit trap 
## Put other needed things in here
CleanUp() {
  [[ -r "$MY_LOCKFILE" ]] && rm -f "$MY_LOCKFILE"
  [[ -d "$MY_TMPDIR" ]] && rm -rf "$MY_TMPDIR"
}

## MoreFunctions()

Argv_call_    ()  { Usage; }
# shellcheck disable=SC2034
Argv_command_info () { info=1; item="$1"; }
# shellcheck disable=SC2034
Argv_command_list () { list=1; item="$1"; }

Dispatch Argv "$@"

## Main()
## Put the main part of the code here below functions

[[ -d "$MY_TMPDIR" ]] || mkdir -p "$MY_TMPDIR" ||
  Emergency "could not create $MY_TMPDIR"

trap CleanUp EXIT

## Do AllThethings

rm "$MY_TMPDIR" || Error "Could not remove $MY_TMPDIR"
trap - EXIT

## brashlib will keep a running count of the number of errors
## encountered that were not 'Emergency' level, in the variable $error
# shellcheck disable=SC2154
exit $error
