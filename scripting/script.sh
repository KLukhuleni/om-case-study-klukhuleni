#!/usr/bin/env bash

set -euo pipefail

exit_code=0

for plan_file in "$@"; do
  echo "Processing $plan_file..."
  if ! jq empty "$plan_file" >/dev/null 2>&1; then
    echo "  Error: '$plan_file' is not valid JSON or not found."
    exit_code=1
    continue
  fi

  change_count=$(jq '.resource_changes | length // 0' "$plan_file")
  if [[ "$change_count" -eq 0 ]]; then
    echo "  No changes detected. Safe to proceed."
    continue
  fi

  errors=0
  for ((i=0; i<change_count; i++)); do
    actions=$(jq -r '.resource_changes['"$i"'].change.actions | join(",")' "$plan_file")
    address=$(jq -r '.resource_changes['"$i"'].address' "$plan_file")

    case "$actions" in
      create)
        ;;
      update)
        before=$(jq -c '.resource_changes['"$i"'].change.before' "$plan_file")
        after=$(jq -c '.resource_changes['"$i"'].change.after' "$plan_file")
        before_clean=$(echo "$before" | jq 'del(.tags.GitCommitHash)')
        after_clean=$(echo "$after" | jq 'del(.tags.GitCommitHash)')
        if [[ "$before_clean" != "$after_clean" ]]; then
          echo "  ERROR: Resource '$address' update modifies more than 'tags.GitCommitHash'."
          errors=$((errors+1))
        fi
        ;;
      *)
        echo "  ERROR: Resource '$address' has forbidden action(s): $actions"
        errors=$((errors+1))
        ;;
    esac
  done

  if [[ "$errors" -eq 0 ]]; then
    echo "  Plan is valid for '$plan_file'. Safe to apply."
  else
    echo "  Plan has $errors issue(s) in '$plan_file'. Should NOT proceed."
    exit_code=1
  fi
done

exit $exit_code
