# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# powerlevel10k
source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme
# syntax highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh


# ---- FZF -----

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# --- setup fzf theme ---
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

# -- Use fd instead of fzf --
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d -d 1 --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd -d 1 --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd -d 1 --type=d --hidden --exclude .git . "$1"
}

show_file_or_dir_preview="
if [ -d {} ]; then eza --tree --color=always {} | head -200; 
else bat -n --color=always --line-range :500 {}; 
fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# functions
function mcd() {
  # mkdir and cd
  mkdir -vp "$1"
  cd "$1"
}

fcd() {
  # fuzzy navigate to directory with preview
  if [ "$1" = "-h" ]; then
    echo "Usage: fcd [depth] [starting_directory]"
    echo "  -h                 Display this help message"
    echo "  depth              Specify the depth of the directory search (default: 1)"
    echo "  starting_directory Specify the directory to start the search (default: .)"
    return
  fi

  local dir
  local depth="${1:-1}"
  local base="${2:-.}"
  local base_name="$(basename "$base")"

  # Preview command for fzf, with custom message for the root directory
  local preview_cmd="
  if [ '{}' = '$base_name' ]; 
  then echo 'Root directory: $base'; 
  elif [ -d '$base/{}' ]; 
  then eza --tree --color=always '$base/{}' | head -200; 
  else bat -n --color=always --line-range :500 '$base/{}'; 
  fi"

  dir=$(find "$base" -maxdepth "$depth" -path '*/\.*' -prune \
          -o -type d -print 2> /dev/null | xargs -I {} basename {} | \
          fzf +m --layout=reverse --preview="$preview_cmd" --height=~50%)

  if [[ "$dir" == "$base_name" ]]; then
    cd "$base"
  else
    cd "$base/$dir"
  fi
}


fcd() {
  # fuzzy navigate to directory with preview
  if [ "$1" = "-h" ]; then
    echo "Usage: fcd [starting_directory] [depth]"
    echo "  -h                 Display this help message"
    echo "  starting_directory Specify the directory to start the search (default: .)"
    echo "  depth              Specify the depth of the directory search (default: 1)"
    return
  fi

  local dir
  local base="${1:-.}"      # Base directory defaults to current directory
  local depth="${2:-1}"     # Depth defaults to 1
  local base_name="$(basename "$base")"

  # Preview command for fzf, with custom message for the root directory
  local preview_cmd="
  if [ '{}' = '$base_name' ]; 
  then echo 'Root directory: $base'; 
  elif [ -d '$base/{}' ]; 
  then eza --tree --color=always '$base/{}' | head -200; 
  else bat -n --color=always --line-range :500 '$base/{}'; 
  fi"

  dir=$(find "$base" -maxdepth "$depth" -path '*/\.*' -prune \
          -o -type d -print 2> /dev/null | xargs -I {} basename {} | \
          fzf +m --layout=reverse --preview="$preview_cmd" --height=~50%)

  if [[ "$dir" == "$base_name" ]]; then
    cd "$base"
  else
    cd "$base/$dir"
  fi
}


# aliases
alias ls="eza -larmh --icons=always --total-size --no-user --no-permissions --git-ignore --sort=name"
alias cleanpath='echo "${PATH//:/\n}"'
alias projects="fcd ~/projects"
alias repos="fcd ~/repos"
alias notes="cd ~/documents/notes"
alias zshrc='code ~/.zshrc'
alias zprofile="code ~/.zprofile"
alias reload="source ~/.zshrc"
alias r="radian"
alias matlab23="open -a /Applications/MATLAB_R2023b.app"
alias matlab24="open -a /Applications/MATLAB_R2024a.app"
alias matlab="matlab23"
alias wlcore="cd /Volumes/Robot/matlab/WL_core"
alias cat="bat"

# keybinds (wezterm esp seqs) 
# -- terminal emulator defines esp sequences send by key combs;
# -- to view, ctrl-v then press key comb (in terminal emulator)
bindkey '^[[D'      backward-char
bindkey '^[[C'      forward-char
bindkey '^?'        backward-delete-char
bindkey '^[[3~'     delete-char           # fn-backspace
bindkey '^[[1;3D'   backward-word         # opt-left
bindkey '^[[1;3C'   forward-word          # opt-right
# bindkey '^H'    backward-kill-word      # opt-backspace
bindkey '^[[3;3~'   kill-word             # fn-opt-backspace

bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
