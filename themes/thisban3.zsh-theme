# Clean, simple, compatible and meaningful.
# Tested on Linux, Unix and Windows under ANSI colors.
# It is recommended to use with a dark background and the font Inconsolata.
# Colors: black, red, green, yellow, *blue, magenta, cyan, and white.
#
# http://ysmood.org/wp/2013/03/my-ys-terminal-theme/
# Mar 2013 ys

SEGMENT_SEPARATOR='▶'

# get the name of the branch we are on
function my_git_prompt_info() {
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null)

    if [ -z "$ref" ]
    then
        echo "%{$bg[default]$fg[blue]%}${SEGMENT_SEPARATOR}"
        return
    fi

    ZSH_THEME_GIT_PROMPT_PREFIX=""
    ZSH_THEME_GIT_PROMPT_SUFFIX="${SEGMENT_SEPARATOR}%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_DIRTY="%{$bg[yellow]$fg[blue]%}${SEGMENT_SEPARATOR}%{$bg[yellow]$fg[black]%} ${ref#refs/heads/} %{$bg[yellow]$fg[black]%}● %{$bg[black]$fg[yellow]%}"
    ZSH_THEME_GIT_PROMPT_CLEAN="%{$bg[green]$fg[blue]%}${SEGMENT_SEPARATOR}%{$bg[green]$fg[black]%} ${ref#refs/heads/} %{$bg[black]$fg[green]%}"

    echo "$(my_parse_git_dirty)${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

# Checks if working tree is dirty
my_parse_git_dirty() {
  local SUBMODULE_SYNTAX=''
  local GIT_STATUS=''
  local CLEAN_MESSAGE='nothing to commit (working directory clean)'
  if [[ "$(command git config --get oh-my-zsh.hide-status)" != "1" ]]; then
    if [[ $POST_1_7_2_GIT -gt 0 ]]; then
          SUBMODULE_SYNTAX="--ignore-submodules=dirty"
    fi
    if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" == "true" ]]; then
        GIT_STATUS=$(command git status -s ${SUBMODULE_SYNTAX} -uno 2> /dev/null | tail -n1)
    else
        GIT_STATUS=$(command git status -s ${SUBMODULE_SYNTAX} 2> /dev/null | tail -n1)
    fi
    if [[ -n $GIT_STATUS ]]; then
      echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
    else
      echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
    fi
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{$fg[red]%}✘"
  [[ $UID -eq 0 ]] && symbols+="%{$fg[yellow]%}⚡"
  # [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

  [[ -n "$symbols" ]] && echo "%{$bg[default]$fg[black]%} $symbols"
}

# Directory info.
local current_dir='${PWD/#$HOME/~}'

# Git info.
local git_info='$(my_git_prompt_info)'

local prompt_status_symbols='$(prompt_status)'
# ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%}%{$reset_color%}%{$fg[cyan]%}"

# Prompt format: \n # USER at MACHINE in DIRECTORY on git:BRANCH STATE [TIME] \n $
PROMPT="${prompt_status_symbols}\
%{$bg[blue]$fg[black]%} \
${current_dir} \
${git_info} \
%{$reset_color%}"
