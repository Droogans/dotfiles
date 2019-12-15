#!/bin/bash

export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# Reset
Color_Off="\[\033[0m\]"       # Text Reset

# Regular Colors
Black="\[\033[0;30m\]"        # Black
Red="\[\033[0;31m\]"          # Red
Green="\[\033[0;32m\]"        # Green
Yellow="\[\033[0;33m\]"       # Yellow
Blue="\[\033[0;34m\]"         # Blue
Purple="\[\033[0;35m\]"       # Purple
Cyan="\[\033[0;36m\]"         # Cyan
White="\[\033[0;37m\]"        # White

# Bold
BBlack="\[\033[1;30m\]"       # Black
BRed="\[\033[1;31m\]"         # Red
BGreen="\[\033[1;32m\]"       # Green
BYellow="\[\033[1;33m\]"      # Yellow
BBlue="\[\033[1;34m\]"        # Blue
BPurple="\[\033[1;35m\]"      # Purple
BCyan="\[\033[1;36m\]"        # Cyan
BWhite="\[\033[1;37m\]"       # White

# Underline
UBlack="\[\033[4;30m\]"       # Black
URed="\[\033[4;31m\]"         # Red
UGreen="\[\033[4;32m\]"       # Green
UYellow="\[\033[4;33m\]"      # Yellow
UBlue="\[\033[4;34m\]"        # Blue
UPurple="\[\033[4;35m\]"      # Purple
UCyan="\[\033[4;36m\]"        # Cyan
UWhite="\[\033[4;37m\]"       # White

# Background
On_Black="\[\033[40m\]"       # Black
On_Red="\[\033[41m\]"         # Red
On_Green="\[\033[42m\]"       # Green
On_Yellow="\[\033[43m\]"      # Yellow
On_Blue="\[\033[44m\]"        # Blue
On_Purple="\[\033[45m\]"      # Purple
On_Cyan="\[\033[46m\]"        # Cyan
On_White="\[\033[47m\]"       # White

# High Intensty
IBlack="\[\033[0;90m\]"       # Black
IRed="\[\033[0;91m\]"         # Red
IGreen="\[\033[0;92m\]"       # Green
IYellow="\[\033[0;93m\]"      # Yellow
IBlue="\[\033[0;94m\]"        # Blue
IPurple="\[\033[0;95m\]"      # Purple
ICyan="\[\033[0;96m\]"        # Cyan
IWhite="\[\033[0;97m\]"       # White

# Bold High Intensty
BIBlack="\[\033[1;90m\]"      # Black
BIRed="\[\033[1;91m\]"        # Red
BIGreen="\[\033[1;92m\]"      # Green
BIYellow="\[\033[1;93m\]"     # Yellow
BIBlue="\[\033[1;94m\]"       # Blue
BIPurple="\[\033[1;95m\]"     # Purple
BICyan="\[\033[1;96m\]"       # Cyan
BIWhite="\[\033[1;97m\]"      # White

# High Intensty backgrounds
On_IBlack="\[\033[0;100m\]"   # Black
On_IRed="\[\033[0;101m\]"     # Red
On_IGreen="\[\033[0;102m\]"   # Green
On_IYellow="\[\033[0;103m\]"  # Yellow
On_IBlue="\[\033[0;104m\]"    # Blue
On_IPurple="\[\033[10;95m\]"  # Purple
On_ICyan="\[\033[0;106m\]"    # Cyan
On_IWhite="\[\033[0;107m\]"   # White

# Various variables you might want for your PS1 prompt instead
Time12h="\T"
Time24h="\t"
Time12a="\@"
PathShort="\w"
PathFull="\W"
NewLine="\n"
Jobs="\j"

alias less='less -R'

alias ~='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cp='cp -i'
alias dc=docker-compose
alias emacs='emacs --no-splash'
function fdiff {
  st=$(git status -s)
  [ -z "$st" ] && return 0
  untracked=$(echo "$st" | grep "??" | cut -d ' ' -f 2)
  untracked_files=$(echo "$untracked" | grep "[^/]$")
  untracked_dirs=$(echo "$untracked" | grep "/$")
  all_untracked=""
  if [ -n "$untracked_files" ]; then
      if [ $(echo "$untracked_files" | wc -l) -gt 1 ]; then
          all_untracked+=$(echo $untracked_files | xargs wc -l | sed '$d' | awk '{print $1 }')$'\n'
      else
          all_untracked+=$(echo $untracked_files | xargs wc -l | awk '{print $1}')$'\n'
      fi
  fi
  if [ $(echo "$untracked_dirs" | wc -l) -gt 0 ]; then
      for dir in $untracked_dirs; do
          all_untracked+=$(echo $dir | xargs -i find {} -name '*' -type f | \
                               xargs wc -l | sed '$d' | cut -d "/" -f 1 | \
                               awk '{arr[$2]+=$1} END {for (i in arr) {print i,arr[i]}}' | \
                               sort | cut -d ' ' -f 2)$'\n'
      done
  else
      all_untracked+=$(echo $untracked_dirs | awk '{print $1}')$'\n'
  fi
  pad_filenames=$(echo "$st" | awk '{ print length + 1 }' | sort -n | tail -1)
  tracked=$(git diff --stat=$((COLUMNS-pad_filenames)) HEAD | sed '$d' | cut -d "|" -f 2 | tr -s '[:blank:]')
  tracked_counts=$(echo "$tracked" | cut -d " " -f 2)
  pad_linecounts_untracked=$(echo "$all_untracked" | awk '{ print $1 }' | awk '{ print length + 1 }' | sort -r | head -n 1)
  pad_linecounts_tracked=$(echo "$tracked_counts" | awk '{ print length + 1 }' | sort -r | head -n 1)
  pad_linecounts=$(paste -d '\n' <(echo $pad_linecounts_tracked) <(echo $pad_linecounts_untracked) | sort -r | head -n 1)
  paste -d "|" \
    <(echo "$st" | awk "{printf \"%-${pad_filenames}s\n\", \$0}") \
    <(if [ -n "$tracked" ]; then
          printf "%${pad_linecounts}s %s\n" $tracked
      fi
      if [ -n "$untracked" ]; then
          printf "%${pad_linecounts}s \033[0;33m+~\033[0m\n" $all_untracked
      fi
     )
}

function killport { kill $(lsof -i :$@ | tail -n 1 | cut -f 5 -d ' '); }
alias kub=kubectl
function kub-context {
    current_context=$(kub config current-context 2>&1)
    if [ $? -eq 0 ]; then
        kub config get-contexts $current_context --no-headers | awk '{printf $2; if ($5) printf ".%s",$5}';
    else
        return 1
    fi
}
function gcp-context {
    active_config=~/.config/gcloud/active_config
    if [ -f $active_config ]; then
        python ~/gcloud_context.py $(cat $active_config);
    else
        return 1
    fi
}
alias tf=terraform
alias ls='ls -lh --color=auto'
alias ll='ls -lAh'
alias ln='ln -is'
alias mkdir='mkdir -pv'
alias mv='mv -i'
function nmb { $(npm bin)/$@; }
alias noisy='unset PS1_NO_VERBOSE'
alias quiet='export PS1_NO_VERBOSE=1'
alias pbc='fc -ln -1 | awk '\''{$1=$1}1'\'' ORS='\'''\'' | xsel -b'
alias sudo='sudo '
# https://brettterpstra.com/2015/02/20/shell-trick-printf-rules/
rulem ()  {
  if [ $# -eq 0 ]; then
    echo "Usage: rulem MESSAGE [RULE_CHARACTER]"
    return 1
  fi
  # Fill line with ruler character ($2, default "-"), reset cursor, move 2 cols right, print message
  printf -v _hr "%*s" $((COLUMNS-3)) && echo -en ${_hr// /${2--}} && echo -e "\r\033[2C$1"
}

function e {
  if [ -z "$1" ]
  then
    TMP="$(mktemp /tmp/stdin-XXX)"
    cat >$TMP
    emacsclient -a emacs -n $TMP
    rm $TMP
  else
    emacsclient -a emacs -n "$@"
  fi
}

kub_prompt() {
    CONTEXT=$(kub-context);
    if [ $? -eq 0 ]; then
        if [[ "$CONTEXT" =~ "prod" ]]; then
            echo " ${IRed}k8s:$CONTEXT$Color_Off";
        else
            echo " ${Yellow}k8s:$CONTEXT$Color_Off";
        fi
    fi
}

gcp_prompt() {
    CONTEXT=$(gcp-context);
    if [ $? -eq 0 ]; then
        if [[ "$CONTEXT" =~ "prod" ]]; then
            echo " ${IRed}gcp:$CONTEXT$Color_Off";
        else
            echo " ${Cyan}gcp:$CONTEXT$Color_Off";
        fi
    fi
}

function venv_prompt() {
    venv=''
    if [ -n "$VIRTUAL_ENV" ]; then
        venv=$(basename $(dirname ${VIRTUAL_ENV}))
    fi
    [ -n "$venv" ] && echo " ${Purple}venv:$venv$Color_Off"
}

ret_prompt() {
    echo "$_returncode_color\\\$?$Color_Off=$_returncode: "
}

prompt() {
    PRE=""
    FMT=""
    POST=""
    inline_status=" "

    function _is_git_dir() {
        $(git branch > /dev/null 2>&1)
        return $?
    }

    if [ -z $_returncode ]; then
        PS1=$LAST_PROMPT
    else
        if [ -z $PS1_NO_VERBOSE ]; then
            # noisy prompt
            if _is_git_dir; then
                status=$(git status -sb | head -n 1)
                if [ "$status" != "${status##*...}" ]; then
                    inline_status="...${status##*...} "
                fi
            fi

            PRE+="$_returncode_color$(rulem "" "▁")$Color_Off\n"
            PRE+="$_returncode_color> $IBlue$Time24h$Color_Off\n"
            PRE+="$IBlue>$IPurple pwd:$PathShort$Color_Off\n"
            context_prompts=$(gcp_prompt)$(kub_prompt)$(venv_prompt)
            if [ -n "$context_prompts" ]; then
                PRE+="$IBlue>$Color_Off$context_prompts\n"
            fi

            if _is_git_dir; then
                PRE+="$IBlue> "
                FMT+="${Green}git:%s$Color_Off"
                POST+="$inline_status\n"
                $(git status | grep "nothing to commit" > /dev/null 2>&1)
                if [ $? -eq 0 ]; then
                    POST+="$(git lg 1 --color)\n$ColorOff"
                    POST+="$(printf "%$(git rev-parse --short HEAD | wc -c)s" " ")-$(git diff --shortstat HEAD~1 HEAD)\n"
                else
                    POST+="$(fdiff)\n"
                fi
            fi

            export LAST_PROMPT="$(ret_prompt)"
            POST+=$LAST_PROMPT
            PS1="$PRE$(__git_ps1 $FMT)$POST"
        else
            # quiet prompt
            PRE+=$IBlue$Time24h$Color_Off
            PRE+=$(gcp_prompt)
            PRE+=$(kub_prompt)
            PRE+=$(venv_prompt)

            if _is_git_dir; then
                $(git status | grep "nothing to commit" > /dev/null 2>&1)
                if [ $? -eq 0 ]; then
                    FMT+="$Green (%s)$Color_Off"
                else
                    FMT+="$IRed {%s}$Color_Off"
                fi
            fi

            POST=" $Yellow$PathShort$Color_Off\n"
            export LAST_PROMPT="$: "
            POST+=$LAST_PROMPT

            PS1="$PRE$(__git_ps1 "$FMT")$POST"
        fi
    fi
}

##
# https://stackoverflow.com/a/27452329
# set the last command's return code in the next PS1
trapDbg() {
   local c="$BASH_COMMAND"
   if [ "$c" != "pc" ] && [ "$c" != "_pyenv_virtualenv_hook" ]; then
       export _cmd="$c"
   fi
}

pc() {
   local r=$?
   trap "" DEBUG
   if [ -n "$_cmd" ]; then
       export _returncode="$r"
   else
       export _returncode=""
   fi

   export _returncode_color=$IRed
   if [ "$_returncode" = "0" ]; then
       export _returncode_color=$Green
   fi
   export _cmd=
   prompt
   trap 'trapDbg' DEBUG
}

export PROMPT_COMMAND=pc
trap 'trapDbg' DEBUG
