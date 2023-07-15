#!/usr/bin/env bash

kc_asdf_load_addon "install" "python"

__asdf_bin() {
  # shellcheck disable=SC2034
  local ns="$1"
  shift

  local type="${ASDF_INSTALL_TYPE:?}"
  local version="${ASDF_INSTALL_VERSION:?}"
  kc_asdf_debug "$ns" "downloading %s %s %s" \
    "$KC_ASDF_APP_NAME" "$type" "$version"
  command -v _kc_asdf_custom_version >/dev/null &&
    kc_asdf_debug "$ns" "developer defined custom version function" &&
    version="$(_kc_asdf_custom_version "$version")"

  local outdir="${ASDF_DOWNLOAD_PATH:?}"
  local install_path="${ASDF_INSTALL_PATH:?}"

  local venv="$install_path/venv"
  kc_asdf_step "init-python" "$venv" \
    kc_asdf_python_init "$venv"

  if kc_asdf_is_ver; then
    kc_asdf_step "download" "$outdir" \
      kc_asdf_python_download "$venv" "$version" "$outdir"
  elif kc_asdf_is_ref; then
    ## TODO: implement reference install type
    kc_asdf_error "$ns" "reference type hasn't been implemented yet"
    return 1
  else
    kc_asdf_error "$ns" "unknown install type (%s)" "$type"
    return 1
  fi
  command -v _kc_asdf_custom_post_download >/dev/null &&
    kc_asdf_debug "$ns" "developer has post download source function defined" &&
    _kc_asdf_custom_post_download "$type" "$version" "$outdir"
  # shellcheck disable=SC2011
  kc_asdf_debug "$ns" "list '%s': [%s]" \
    "$outdir" "$(ls "$outdir" | xargs echo)"
}
