function fish_right_prompt
  # Set git status indicators if we are in a git repo
  if git_is_dirty
    printf "$c4✘ "
  else
    printf "$c3✔ "
  end
  if git_is_staged
    printf "$c3⚓ "
  end
  if test $git_dirty_count -gt 0
    printf "$c0:$c3 ∑ $git_dirty_count"
  end

  # Record last exit code
  set -l exit_code $status
  set_color -o 666
  echo ' |'
  printf $c2
  if test $exit_code -ne 0
    printf $c4
  end
  printf '%d' $exit_code

  # Echo current time
  set_color -o 666
  echo '|'
  set_color -o 777
  printf '%s' (date +%H:%M:%S)
  set_color normal
end