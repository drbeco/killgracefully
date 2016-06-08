#!/bin/bash
#
# **************************************************************************
# * killgracefully.sh                         Version 20160608.000924      *
# *                                                                        *
# * (C)opyright 2016         by Ruben Carlo Benante                        *
# * Brief:                                                                 *
# * Sends a series of signals to a PID to warn the process it should quit  *
# *                                                                        *
# * This program is free software; you can redistribute it and/or modify   *
# *  it under the terms of the GNU General Public License as published by  *
# *  the Free Software Foundation version 2 of the License.                *
# *                                                                        *
# * This program is distributed in the hope that it will be useful,        *
# *  but WITHOUT ANY WARRANTY; without even the implied warranty of        *
# *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
# *  GNU General Public License for more details.                          *
# *                                                                        *
# * You should have received a copy of the GNU General Public License      *
# *  along with this program; if not, write to the                         *
# *  Free Software Foundation, Inc.,                                       *
# *  59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
# *                                                                        *
# * Contact author at:                                                     *
# *  Ruben Carlo Benante                                                   *
# *  rcb@beco.cc                                                           *
# **************************************************************************

Help()
{
  cat << EOF
  killgracefully - Send signals to kill gracefully a process
  Usage: ${1} [-v] ( [-h|-V] | [-t S] [-N] -p PID )

  Options:
    -h, --help              Show this help.
    -V, --version           Show version.
    -v, --verbose           Turn verbose mode on (cumulative).
    -t S, --time S          Set the interval between signals in seconds. (default 5s)
    -p PID, --pid PID       Set the PID of the process to kill gracefully
    -N, -s N, --sigs N      Set the numbers of signals to try. The order is:
    -1                      SIGKILL
    -2                      SIGTERM, SIGKILL
    -3                      SIGTERM, SIGINT, SIGKILL
    -4                      SIGTERM, SIGINT, SIGQUIT, SIGKILL (default)    
    -5                      SIGTERM, SIGINT, SIGQUIT, SIGABRT, SIGKILL     

    Table of signals with default action 
    of terminate (with or without core dump)

Signal     Value     Action   Comment
----------------------------------------------------------------------
SIGTERM      15       Term    Termination signal
SIGINT        2       Term    Famous CONTROL+C interrupt from keyboard
SIGQUIT       3       Core    CONTRL+\ or quit from keyboard
SIGABRT       6       Core    Abort signal
SIGKILL       9       Term    Kill signal
    
  Exit status:
     0, if ok.
     1, some error occurred.

  Todo:
          Long options not implemented yet.

  Author:
          Written by Ruben Carlo Benante <rcb@beco.cc>  

EOF
  exit 1
}
# Another usage function example
# usage() { echo "Usage: $0 [-h | -c] | [-a n -i m], being n>m" 1>&2; exit 1; }

Copyr()
{
  echo 'killgracefully - 20160608.000924'
  echo
  echo 'Copyright (C) 2016 Ruben Carlo Benante <rcb@beco.cc>, GNU GPL version 3 or later'
  echo '<http://gnu.org/licenses/gpl.html>. This  is  free  software:  you are free to change and'
  echo 'redistribute it. There is NO WARRANTY, to the extent permitted by law. USE IT AS IT IS. The author'
  echo 'takes no responsability to any damage this software may inflige in your data.'
  echo
  exit 1
}

# Entry point 
Main()
{
  verbose=0
  nsignals=4
  time=3
  pid=0
  lista="15 2 3 9"
  #getopt example with switch/case
  while getopts "hVvt:s:12345p:" FLAG; do
    case $FLAG in
      h)
        Help
        ;;
      V)
        Copyr
        ;;
      v)
        let verbose=verbose+1
        ;;
      t)
        time=$OPTARG
        ;;
      s)
        nsignals=$OPTARG
        ;;
      p)
        pid=$OPTARG
        ;;
      1) #SIGKILL
        nsignals=1
        lista="9"
        ;;
      2) #SIGTERM #SIGKILL
        nsignals=2
        lista="15 9"
        ;;
      3) #SIGTERM SIGINT SIGKILL
        nsignals=3
        lista="15 2 9"
        ;;
      4) #SIGTERM SIGINT SIGQUIT SIGKILL
        nsignals=4
        lista="15 2 3 9"
        ;;
      5) #SIGTERM SIGINT SIGQUIT SIGABRT SIGKILL
        nsignals=5
        lista="15 2 3 6 9"
        ;;
      *)
        Help
        ;;
    esac
  done

  if [ "$time" -lt 1 ] || [ "$time" -gt 60 ]; then
    echo "Restriction: time between signals from 1 to 60 seconds only. Use -h for help"
    exit 1
  fi
  if [ "$nsignals" -lt 1 ] || [ "$nsignals" -gt 5 ]; then
    echo "Restriction: number of signals from 1 to 5 only. Use -h for help"
    exit 1
  fi
  if [ "$pid" -eq 0 ]; then
    echo "Error: -p PID is mandatory. Use -h for help"
    exit 1
  fi
  if [ $verbose -gt 0 ]; then
      echo "Starting killgracefully.sh script, by beco, version 20160608.000924"
      echo "Verbose level: $verbose"
      echo "PID of the process to kill: $pid"
      echo "Number of signals to send: $nsignals"
      if [ $verbose -gt 1 ]; then
        echo "Signals to send: $lista"
      fi
      echo "Time between signals: $time"
  fi

  #    -1      SIGKILL
  #    -2      SIGTERM, SIGKILL
  #    -3      SIGTERM, SIGINT, SIGKILL
  #    -4      SIGTERM, SIGINT, SIGQUIT, SIGKILL (default)    
  #    -5      SIGTERM, SIGINT, SIGQUIT, SIGABRT, SIGKILL     

  #for each signal
  for sig in $lista; do
    if [ $verbose -gt 1 ]; then
      echo "Trying: kill -$sig $pid"
    fi
    kill -$sig $pid 2>/dev/null
    if [ $? -ne 0 ]; then
      if [ $verbose -gt 1 ]; then
        echo 'Kill error. Job done? Check it out.'
      fi
      break
    fi
    if [ $verbose -gt 1 ]; then
      echo "Sleeping for $time"
    fi
    sleep $time
  done
}

#Calling main with all args
Main $*
exit 0

#/* ---------------------------------------------------------------------- */
#/* vi: set ai et ts=2 sw=2 tw=0 wm=0 fo=croql : C config for Vim modeline */
#/* Template by Dr. Beco <rcb at beco dot cc> Version 20150619.231433      */

