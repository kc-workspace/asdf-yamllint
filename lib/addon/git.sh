#!/usr/bin/env bash

## Git clone with branch selection support
## usage: `kc_asdf_git_clone '<git-repo>' '/tmp/repo' [main]`
kc_asdf_git_clone() {
  local repo="$1" location="$2" branch="${3:-}"
  local args=(clone)

  ## Make clone quiet
  args+=(--quiet --config "advice.detachedHead=false")
  ## Clone only single branch
  args+=(--single-branch)
  [ -n "$branch" ] &&
    args+=(--branch "$branch")
  args+=("$repo" "$location")

  kc_asdf_exec git "${args[@]}"
}
