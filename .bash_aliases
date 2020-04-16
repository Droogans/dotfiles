#!/bin/bash

export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

function scolor() {
    echo "$1" | sed "s/\\\\\\[//g; s/\\\\\\]//g"
}

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

bind '"\C-l": " source ~/.bash_aliases; history -r; clear\n"'

alias ?="echo $?"
alias less='less -R'

alias ~='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cp='cp -i'
alias dc=docker-compose
alias emacs='emacs --no-splash'
function fdiff {
  st_full=$(git status -sb)
  st=$(echo "$st_full" | sed '1d')
  [ -z "$st" ] && return 0
  untracked=$(echo "$st" | grep "??" | cut -d ' ' -f 2)
  untracked_files=$(echo "$untracked" | grep "[^/]$")
  untracked_dirs=$(echo "$untracked" | grep "/$")
  all_untracked=""
  if [ -n "$untracked_files" ]; then
      if [ $(echo "$untracked_files" | wc -l) -gt 1 ]; then
          all_untracked+=$(echo "$untracked_files" | xargs wc -l | sed '$d' | awk '{print $1 }')$'\n'
      else
          all_untracked+=$(echo "$untracked_files" | xargs wc -l | awk '{print $1}')$'\n'
      fi
  fi
  if [ $(echo "$untracked_dirs" | wc -l) -gt 0 ]; then
      for dir in $untracked_dirs; do
          all_untracked+=$(tar -c "$dir" | wc -l)$'\n'
      done
  else
      all_untracked+=$(echo "$untracked_dirs" | awk '{print $1}')$'\n'
  fi

  all_tracked=""
  tracked=
  if ! echo "$st_full" | head -n 1 | grep "^## No commits yet on\s" 2>&1 >/dev/null; then
      tracked=$(git diff --stat HEAD | sed '$d' | cut -d "|" -f 2 | tr -s '[:blank:]')
      for tracked_file in "$tracked"; do
          all_tracked+="$tracked_file"$'\n'
      done
      all_tracked=$(echo "$all_tracked" | sed '$d')
  fi

  python ~/fdiff.py "$st" "$all_tracked" "$all_untracked"
}

function killport { kill $(lsof -i :$@ | tail -n 1 | cut -f 5 -d ' '); }
alias kub=kubectl
function kubn {
  # kvaps/kubectl-use/blob/b967f15204b357b71d9792c16d664bb26de57e68/kubectl-use
  _k8s_current_context=$(kub config get-contexts $(kub config current-context) --no-headers)

  if [ "$1" = "-" ]; then
      kub config use "$_k8s_prev_context" > /dev/null
      kub config set-context --current --namespace="$_k8s_prev_namespace" > /dev/null
  fi

  export _k8s_prev_context="$(echo "$_k8s_current_context" | awk '{ printf $2 }')"
  export _k8s_prev_namespace="$(echo "$_k8s_current_context" | awk '{ printf $5 }')"
  _k8s_current_context=

  if [ "$1" = "-" ]; then
      return 0
  fi

  for context in $(kub config get-contexts -o name); do
    if [ "$1" = "$context" ]; then
      _k8s_new_context="$1"
      break
    fi
  done
  context=

  if [ -n "$_k8s_new_context" ]; then
    kub config use "$1"
    if [ -n "$2" ]; then
      _k8s_new_namespace="$2"
    fi
  else
    if [ -n "$2" ]; then
      echo "Can not switch context \"$1\"."
      return 1
    fi
    _k8s_new_namespace="$1"
  fi

  if [ -n "$_k8s_new_namespace" ]; then
    kub config set-context --current --namespace="$_k8s_new_namespace" > /dev/null
  fi

  _k8s_new_context=
  _k8s_new_namespace=
}

function kub-context {
    __k8s_context=$(kub config current-context 2>&1 > /dev/null)
    if [ $? -eq 0 ]; then
        kub config get-contexts "$__k8s_context" --no-headers | awk '{printf $2; if ($5) printf ".%s",$5}'
    fi
}
function gcp-context { [ -f ~/.config/gcloud/active_config ] && $CLOUDSDK_PYTHON ~/gcloud_context.py $(cat ~/.config/gcloud/active_config); }
function gcloudn {
  export _gcloud_current_context="$(cat ~/.config/gcloud/active_config)"

  if [ "$1" = "-" ]; then
      _suppressed=$(gcloud config configurations activate "$_gcloud_prev_context" 2>&1 > /dev/null)
      _suppressed=
  fi

  if [ "$1" = "-" ]; then
      export _gcloud_prev_context=$_gcloud_current_context
      return 0
  fi

  export _gcloud_prev_context="$(cat ~/.config/gcloud/active_config)"

  _suppressed=$(gcloud config configurations activate "$1" 2>&1 > /dev/null)
  _suppressed=
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
    if command -v kubectl &>/dev/null; then
        CONTEXT=`kub-context`;
        if [[ "$CONTEXT" =~ "prod" ]]; then
            echo " ${IRed}k8s:$CONTEXT$Color_Off";
        else
            echo " ${Yellow}k8s:$CONTEXT$Color_Off";
        fi
    fi
}

gcp_prompt() {
    if command -v gcloud &>/dev/null; then
        CONTEXT=`gcp-context`;
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
    else
        venv=$(pyenv version-name 2>&1)
        if [ $? -gt 0 ]; then
            venv="$IRed$(echo "$venv" | tail -n 1 | sed -n "s/^pyenv: version \`\(.*\)' is not installed.*$/\1/p")$Color_Off??"
        fi
    fi
    [ -n "$venv" ] && echo " ${Purple}venv:$venv$Color_Off"
}

ret_prompt() {
    if [ -z $PS1_NO_VERBOSE ]; then
        echo "$_returncode_color\\\$?$Color_Off=$_returncode: "
    else
        echo "$_returncode_color\\\$$Color_Off: "
    fi
}

prompt() {
    _exectime=$(perl -MPOSIX -MTime::HiRes=time -e 'printf "%s (%.3fs)", (strftime "%H:%M:%S", localtime), time - @ARGV[0]' $_cmdtime)
    PRE=""
    FMT=""
    POST=""
    inline_status=" "
    _git_dir_info="$(git status -sb --porcelain=2 2>&1)"
    _git_dir_info_is_repository="1"
    if echo "$_git_dir_info" | \
            grep -e "fatal: not a git repository" \
                 -e "fatal: Unable to read current working directory" \
                 2>&1 >/dev/null; then
       _git_dir_info_is_repository=
    fi

    if [ -z $_returncode ]; then
        PS1=$LAST_PROMPT
    else
        if [ -d $(pwd) ]; then
            _path="$PathShort$Color_Off\n"
        else
            _path="$Red$PathShort$Color_Off??\n"
        fi

        if [ -z $PS1_NO_VERBOSE ]; then
            PRE+="\n$_returncode_color$(rulem "" "—")$Color_Off\n"
            PRE+="$_returncode_color> $IBlue$_exectime$Color_Off\n"
            PRE+="$IBlue>$IPurple pwd:$_path"
            context_prompts=$(gcp_prompt)$(kub_prompt)$(venv_prompt)
            if [ -n "$context_prompts" ]; then
                PRE+="$IBlue>$Color_Off$context_prompts\n"
            fi

            if [ -n "$_git_dir_info_is_repository" ]; then
                PRE+="$IBlue> "
                FMT+="${Green}git:%s$Color_Off"
                _git_status_info_headers=$(echo "$_git_dir_info" | grep "^#\s")
                _git_nothing_to_commit=
                if [ "$_git_dir_info" = "$_git_status_info_headers" ]; then
                    _git_nothing_to_commit="1"
                fi

                _git_status_info=($(echo "$_git_status_info_headers" | awk '{ print $3 }'))
                _git_status_info_ref=${_git_status_info[0]}
                if [ "${_git_status_info[0]}" = "(initial)" ]; then
                    _git_status_info_initial_commit="1"
                else
                    _git_status_info_initial_commit=
                    _git_status_info_shortsha=$(git rev-parse --short HEAD)
                fi

                _git_status_info_upstream=${_git_status_info[2]}

                if [ -n "$_git_status_info_initial_commit" ]; then
                    POST+="@${Yellow}inital$Color_Off"
                else
                    if [ -z "$_git_nothing_to_commit" ]; then
                        POST+="@${Red}$_git_status_info_shortsha$Color_Off"
                    fi
                fi

                if [ -n "$_git_status_info_upstream" ]; then
                    POST+="...$Green$_git_status_info_upstream$Color_Off "
                fi

                POST+="\n"

                if [ -n "$_git_nothing_to_commit" ] && [ -z "$_git_status_info_initial_commit" ]; then
                    POST+="$(git lg 1 --color)\n$ColorOff"
                    POST+="$(printf "%$(echo "$_git_status_info_shortsha" | wc -c)s" " ")-$(git diff --shortstat HEAD~1 HEAD)\n"
                else
                    POST+="$(fdiff)\n"
                fi
                FMT=$(__git_ps1 "$FMT")
            fi
        else
            # quiet prompt
            PRE+=$IBlue$Time24h$Color_Off
            PRE+=$(gcp_prompt)
            PRE+=$(kub_prompt)
            PRE+=$(venv_prompt)

            if [ -n "$_git_dir_info_is_repository" ]; then
                if git status | grep "nothing to commit" > /dev/null 2>&1; then
                    FMT+="$Green (%s)$Color_Off"
                else
                    FMT+="$Red {%s}$Color_Off"
                fi
                FMT=$(__git_ps1 "$FMT")
            fi
            POST=" $Yellow$_path"
        fi
        export LAST_PROMPT="$(ret_prompt)"
        POST+=$LAST_PROMPT
        PS1="$PRE$FMT$POST"
    fi
}

##
# https://stackoverflow.com/a/27452329
# set the last command's return code in the next PS1
trapDbg() {
    local c="$BASH_COMMAND"
    history -a
    if [ "$c" != "pc" ] && [ "$c" != "_pyenv_virtualenv_hook" ]; then
        export _cmd="$c"
        export _cmdtime=$(perl -MTime::HiRes=time -e 'printf "%s", time' &)
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

    export _returncode_color=$Red
    if [ "$_returncode" = "0" ]; then
        export _returncode_color=$Green
    fi
    export _cmd=
    prompt
    trap 'trapDbg' DEBUG
}

export PROMPT_COMMAND=pc
trap 'trapDbg' DEBUG
