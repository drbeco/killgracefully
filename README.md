# killgracefully

Script to kill a process gracefully

## Usage

killgracefully - Send signals to kill gracefully a process
  
**Usage: ./killgracefully.sh [-v] ( [-h|-V] | [-t S] [-N] -p PID )**

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

## Signals used

### Table of signals with default action of terminate (with or without core dump)

|Signal    | Value  |   Action |  Comment |
|----------|--------|----------|------------------------------------------ |
|SIGTERM   |   15   |    Term  |  Termination signal |
|SIGINT    |    2   |    Term  |  Famous CONTROL+C interrupt from keyboard |
|SIGQUIT   |    3   |    Core  |  CONTRL+\ or quit from keyboard |
|SIGABRT   |    6   |    Core  |  Abort signal |
|SIGKILL   |    9   |    Term  |  Kill signal |
    
## Exit status

- 0, if ok.
- 1, if some error occurred (mainly about the usage)
