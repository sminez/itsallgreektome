# Modified from ideas on https://geraldkaszuba.com/tweaking-fish-shell/

function _common_section
    printf $c1
    printf $argv[1]
    printf $c0
    printf ":"
    printf $c2
    printf $argv[2]
    printf $argv[3]
    printf $c0
    printf ""
end

function section
    _common_section $argv[1] $c3 $argv[2] $ce
end

function error
    _common_section $argv[1] $ce $argv[2] $ce
end

function git_branch
    set -g git_branch (git rev-parse --abbrev-ref HEAD ^ /dev/null)
    if [ $status -ne 0 ]
        set -ge git_branch
        set -g git_dirty_count 0
    else
        set -g git_dirty_count (git status --porcelain  | wc -l | sed "s/ //g")
    end
end

function fish_prompt
    # $status gets nuked as soon as something else is run, e.g. set_color
    # so it has to be saved asap.
    set -l last_status $status

    # c0 to c4 progress from dark to bright
    # ce is the error colour
    set -g c0 (set_color 655643)
    set -g c1 (set_color 80BCA3)
    set -g c2 (set_color A8A297)
    set -g c3 (set_color F6DC37)
    set -g c4 (set_color EF4D28)
    set -g ce (set_color $fish_color_error)

    # Clear the line because fish seems to emit the prompt twice. The initial
    # display, then when you press enter.
    printf "\033[K"

    # User details
    if [ $USER = root ]
      printf "$c4$USER$c0@$c3"
    else
      printf "$c3$USER$c0@$c3"
    end
    echo (hostname) | tr -d '\n'
    printf "$c0 ζ "

    # Virtual Env: alternate icons - ᔞ  ⍫ ⍱ ♈  ⚕ ℣
    if set -q VIRTUAL_ENV
        echo -n '≼ '
        section ⚕ (basename "$VIRTUAL_ENV")
        echo -n "≽ "
    end

    # Set git branch name
    git_branch
    if git_is_repo
        set -g branchName (git_branch_name)
        echo -n '≺ '
        section  $branchName
        echo -n "≻ "
    end

    # Current Directory
    # awk to truncate paths
    # 1st sed for colourising forward slashes
    # 2nd sed for colourising the deepest path (the 'm' is the last char in the
    # ANSI colour code that needs to be stripped)
    printf $c1
    printf (pwd | awk -F'/' '{if (NF < 4) { print } else { print "../" $(NF-1)"/"$NF }}' | sed "s,/,$c0/$c1,g" | sed "s,\(.*\)/[^m]*m,\1/$c3,")

    # Prompt on a new line
    # Alternative unicode prompt chars: λ ζ ∑ ∈ ∮ ⚓ ✘ ✔ ➥ ⊶    こくの  コクネ
    printf $c4
    printf "\nλ く"
end
