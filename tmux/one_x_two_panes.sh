#!/bin/bash

SESH="local"
SERVER_DIR="fill this out"
CLIENT_DIR="fill this out"

tmux has-session -t $SESH 2>/dev/null

if [ $? != 0 ]; then
    tmux new-session -d -s $SESH -n "FIELD_ANALYZER"

    tmux new-window -t $SESH -n "ALL_PROCESSES"
    tmux send-keys -t $SESH:ALL_PROCESSES "cd $SERVER_DIR" C-m

    tmux new-window -t $SESH -n "CLIENT"
    tmux send-keys -t $SESH:CLIENT "cd $CLIENT_DIR;" C-m

    tmux join-pane -s $SESH:CLIENT -t $SESH:ALL_PROCESSES

    tmux select-layout -t $SESH:ALL_PROCESSES even-horizontal

    tmux select-window -t $SESH:ALL_PROCESSES
fi

tmux attach-session -t $SESH