#!/usr/bin/env bash
################################################################################
## dispatch.sh
##
## Bash argument parser -- dispatches calls of commands and arguments
##
## Modified from https://github.com/Mosai/workshop
##
## Copyright (C) 2014 Akexandre Gaigalas
## Copyright (C) 2016 Trey Palmer
##
## Permission is hereby granted, free of charge, to any person obtaining a
## copy of this software and associated documentation files (the "Software"),
## to deal in the Software without restriction, including without limitation
## the rights to use, copy, modify, merge, publish, distribute, sublicense,
## and/or sell copies of the Software, and to permit persons to whom the
## Software is furnished to do so, subject to the following conditions:
##
## The above copyright notice and this permission notice shall be included in
## all copies or substantial portions of the Software.
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
## FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
## DEALINGS IN THE SOFTWARE.
##
################################################################################

Dispatch ()
{
  namespace="$1"     # Namespace to be dispatched
  arg="${2:-}"       # First argument
  short="${arg#-}"   # First argument without leading -
  long="${short#-}"  # First argument without leading --

  ## Exit and warn if no first argument is found
  if [[ -z "$arg" ]]; then
    "${namespace}_"    ## Call empty call placeholder
    return 1
  fi

  shift 2    ## Remove namespace and first argument from $@

  ## Detects if a command, --long or -short option was called
  case "$arg" in
    "--$long" )
        longname="${long%%=*}" # Long argument before the first = sign

        if [[ "$long" != "$longname" ]]; then
          longval="${long#*=}"
          long="$longname"
          set -- "$longval" "${@:-}"
        fi

        main_call=${namespace}_option_${long}
      ;;

    "-$short" )
        main_call=${namespace}_option_${short}
      ;;
    *)
        main_call=${namespace}_command_${arg}
      ;;
  esac

  if [[ $(type -t "$main_call" 2>/dev/null) == "function" ]]; then
    $main_call "${@}" && dispatch_returned=$? || dispatch_returned=$?
  else
    "${namespace}_call_" "$namespace" "$arg" "$@"      # Default for unspecified call
    return 1
  fi

  return $dispatch_returned
}
