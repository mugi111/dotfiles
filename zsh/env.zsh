# Machine-local environment overrides that should not live in the repo.
for env_file in \
  "$HOME/.zshenv.local" \
  "$HOME/.config/env.local"
do
  [[ -f "$env_file" ]] && source "$env_file"
done
