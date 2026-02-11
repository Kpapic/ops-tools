#tail_error_history.sh

A small script to display the last 5 ERROR lines from a log file.

#What it does

Finds all ERROR lines
Displays only the last 5 (most recent)
Does not use exit codes, only human-readable output

#Examples

./tail_error_history.sh
./tail_error_history.sh /path/log
./tail_error_history.sh /path/log 10
