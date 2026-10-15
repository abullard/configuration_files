#!/bin/bash

SESH="local"
APP_ONE_SERVER=""
APP_ONE_CLIENT=""
APP_TWO_SERVER=""
APP_TWO_CLIENT=""


# 10/15/2026 AJB keeping docker stuff around for reference
# start this first to give it time to spin up
# docker desktop start
# echo "---"
# echo ""

# did the last command exit successfully?
# i.e. did Docker Desktop start?
# if [ $? != 0 ]; then
#     echo "There was a problem starting the Docker Desktop App"
#     exit
# fi

# check for an existing session with this name
tmux has-session -t $SESH 2>/dev/null

# did the last command exit successfully?
# i.e. do we already have this session open in the background?
if [ $? != 0 ]; then
    # create a new session
    tmux new-session -d -s $SESH -n "TWO_X_TWO"

    # start map server
    tmux new-window -t $SESH -n "ALL_PROCESSES"
    # C-m sends an 'Enter' key to kick off this CLI command
    tmux send-keys -t $SESH:ALL_PROCESSES "cd $APP_ONE_SERVER" C-m

    # start map client
    tmux new-window -t $SESH -n "APP_ONE_CLIENT"
    # we don't send C-m here, because it will error if map-server isn't spun up first
    tmux send-keys -t $SESH:APP_ONE_CLIENT "cd $APP_ONE_CLIENT"

    # start field analyzer server after fetching cloudme credentials
    tmux new-window -t $SESH -n "APP_TWO_SERVER"
    tmux send-keys -t $SESH:APP_TWO_SERVER "cloudme -m --skip-update; cd $APP_TWO_SERVER" C-m

    # start field analyzer client
    tmux new-window -t $SESH -n "APP_TWO_CLIENT"
    tmux send-keys -t $SESH:APP_TWO_CLIENT "cd $APP_TWO_CLIENT" C-m

    # join the windows we created into four panes on our first window
    tmux join-pane -s $SESH:APP_ONE_CLIENT -t $SESH:ALL_PROCESSES
    tmux join-pane -s $SESH:APP_TWO_SERVER -t $SESH:ALL_PROCESSES
    tmux join-pane -s $SESH:APP_TWO_CLIENT -t $SESH:ALL_PROCESSES

    # tile the layout
    tmux select-layout -t $SESH:ALL_PROCESSES tiled

    # ensure the window running all these sessions is visible
    tmux select-window -t $SESH:ALL_PROCESSES
fi

# attach the tmux session to the foreground
tmux attach-session -t $SESH