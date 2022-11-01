#!/bin/bash

# Creates Codefresh pipeline variables which can be used to automate a
# pretend developer making commits to a demo Git repo (changing a color).

# Outputs
# -------
# SKIP_THIS_TIME = true or false; frequency determined by the input ratio
# COLOR_CHOICE = 1 of 7 randomized colors to include in the code change/commit
# JIRA_ISSUE = 1 of 4 randomized JIRA issue numbers (they start with SA-)
# COMMIT_MESSAGE = 1 of 4 randomized commit messages
# COMMITTER_NAME = 1 of 2 randomized committer names
# COMMITTER_EMAIL = corresponding committer email

# Arguments
# ---------
# $SKIP_THIS_TIME = if this already exists, then the args are ignored
# $1 = Skip ratio numerator (required if $SKIP_THIS_TIME not provided)
# $2 = Skip ratio denominator (required if $SKIP_THIS_TIME not provided)
# For example, if you want to skip 2 out of every 5 times this script runs
# then you would call it like this:
# ./generate-change-vars.sh 2 5

# Note: Output variables are published with both export and cf_export. Export
# allows other commands in the same freestyle step as this script to see
# the variables, and cf_export allows subsequent steps to see the variables.

function random_skip() {
    # Sets output var SKIP_THIS_TIME to true or false
    echo "Randomly skip approx $SKIP_TIMES out of every $CHANCES runs..."
    let DECISION_POINT=CHANCES-SKIP_TIMES
    # Generate a random number from 1 to 5
    THIS_TIME=$((1 + $RANDOM % $CHANCES))
    if [ $THIS_TIME -le $DECISION_POINT ]
        then {
            # echo 'Not skipping this time'
            export SKIP_THIS_TIME=false
        }
        else {
            # echo 'Skipping this time'
            export SKIP_THIS_TIME=true
        }
    fi
    cf_export SKIP_THIS_TIME || true
}

function choose_color() {
    # Sets output var COLOR_CHOICE
    declare -a COLOR_LIST=("LemonChiffon" "LightCyan" "LightBlue" \
    "LightGoldenRodYellow" "LightGrey" "Lavender" "HoneyDew")
    COLOR_INDEX=$(($RANDOM % 7))
    export COLOR_CHOICE=${COLOR_LIST[COLOR_INDEX]}
    cf_export COLOR_CHOICE || true
    # echo "Color choice: $COLOR_CHOICE"
}

function choose_jira_issue() {
    # Sets output var JIRA_ISSUE
    declare -a ISSUE_LIST=("SA-156" "SA-157" "SA-158" "SA-159")
    ISSUE_INDEX=$(($RANDOM % 4))
    export JIRA_ISSUE=${ISSUE_LIST[ISSUE_INDEX]}
    export JIRA_ISSUE_PREFIX=SA
    cf_export JIRA_ISSUE || true
    # echo "JIRA issue: $JIRA_ISSUE"
}

function choose_commit_message() {
    # Sets output var COMMIT_MESSAGE
    declare -a MESSAGE_LIST=("Update style.css" "Update background color" \
        "Apply $COLOR_CHOICE color scheme" "Add highlights for pizzaz")
    MESSAGE_INDEX=$(($RANDOM % 4))
    export COMMIT_MESSAGE=${MESSAGE_LIST[MESSAGE_INDEX]}
    cf_export COMMIT_MESSAGE || true
    # echo "Commit message: $COMMIT_MESSAGE"
}

function choose_commiter() {
    # Sets output vars COMMITTER_NAME and COMMITTER_EMAIL
    declare -a NAME_LIST=("TedSpinks" "dustinvanbuskirk" "ahromis")
    declare -a EMAIL_LIST=("ted.spinks@codefresh.io" "dev@vanbuskirk.me" "ahromis@gmail.com")
    COMMITTER_INDEX=$(($RANDOM % 3))
    export COMMITTER_NAME=${NAME_LIST[COMMITTER_INDEX]}
    export COMMITTER_EMAIL=${EMAIL_LIST[COMMITTER_INDEX]}
    cf_export COMMITTER_NAME || true
    cf_export COMMITTER_EMAIL || true
    # echo "Committer: $COMMITTER_NAME $COMMITTER_EMAIL"
}


# **************************** Main Area *****************************
# Get inputs
SKIP_TIMES=$1   # skip ratio numerator
CHANCES=$2      # skip ratio denominator

# If $SKIP_THIS_TIME doesn't already exist, create it
if [ -z "$SKIP_THIS_TIME" ]
  then 
    if [ -z "$SKIP_TIMES" ]; then echo Missing script arguments; exit 1; fi
    if [ -z "$CHANCES" ]; then echo Missing 2nd script argument; exit 1; fi
    random_skip
fi

choose_color
choose_jira_issue
choose_commit_message
choose_commiter
