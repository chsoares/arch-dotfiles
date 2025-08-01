# function fish_prompt -d "Write out the prompt"
#     # This shows up as USER@HOST /home/user/ >, with the directory colored
#     # $USER and $hostname are set by fish, so you can just use them
#     # instead of using `whoami` and `hostname`
#     printf '%s@%s %s%s%s > ' $USER $hostname \
#         (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
# end

starship init fish | source
if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_greeting
    fastfetch
end

set -x PYTHONWARNINGS "ignore"

# Aliases
source ~/.config/fish/aliases.fish
alias pamcan pacman
alias clear "printf '\033[2J\033[3J\033[1;1H'"

# Fzf.fish
fzf_configure_bindings --directory=\cf --variables=\e\cv

string match -q "$TERM_PROGRAM" "kiro" and . (kiro --locate-shell-integration-path fish)
