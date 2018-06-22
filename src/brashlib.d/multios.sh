#!/usr/bin/env bash
##
## common aliases and functions to bridge OS components across different OSes
##
###################

# shellcheck disable=SC2034

# Fix 'date' disparity across Solaris/Illumos, FreeBSD, and Linux
# requires gnu-date installed on Solarishes, 'coreutils' pkg on FreeBSD
if [ -x "/usr/gnu/bin/date" ]; then       ## Solaris
  gdate="/usr/gnu/bin/date"
elif [ -x "/usr/local/bin/gdate" ]; then  ## FreeBSD
  gdate="/usr/local/bin/gdate"
else                                      ## Linux
  gdate="/bin/date"
fi
