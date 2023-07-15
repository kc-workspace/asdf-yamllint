#!/usr/bin/env bash

kc_asdf_python() {
  local ns="python.addon"
  local cmd="python3"
  command -v "$cmd" >/dev/null ||
    cmd="python"

  if "$cmd" --version | grep -qE 'Python 3'; then
    kc_asdf_exec "$cmd" "$@"
    return $?
  fi

  kc_asdf_error "$ns" "cannot found python3 anywhere"
  return 1
}

## Initiate python venv on input location
## usage: `kc_asdf_python_init /tmp/download`
kc_asdf_python_init() {
  local input="$1"
  kc_asdf_python -m venv \
    --clear --upgrade-deps "$input"
}

## Download package to target directory.
## First input must by directory contains `bin/python` file
## usage: `kc_asdf_python_download '/tmp/venv' '1.1.1' '/tmp/download'`
kc_asdf_python_download() {
  local venv="$1" version="$2" target="$3"
  local python="$venv/bin/python"
  if [ -f "$python" ]; then
    ## https://pip.pypa.io/en/stable/cli/pip_download/
    kc_asdf_exec "$python" -m pip \
      download "$KC_ASDF_APP_NAME==$version" \
      --quiet --dest "$target"
    return $?
  fi
  return 1
}

## Install package from downloaded directory.
## First input must by directory contains `bin/python` file
## usage: `kc_asdf_python_install '/tmp/venv' '/tmp/download'`
kc_asdf_python_install() {
  local venv="$1" target="$2"
  local python="$venv/bin/python"
  if [ -f "$python" ]; then
    ## https://pip.pypa.io/en/stable/cli/pip_install/
    kc_asdf_exec "$python" -m pip \
      install "$KC_ASDF_APP_NAME" \
      --quiet --progress-bar off --no-index --find-links "$target"
    return $?
  fi
  return 1
}
