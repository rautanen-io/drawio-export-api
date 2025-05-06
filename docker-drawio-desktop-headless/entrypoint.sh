#!/usr/bin/env bash

# This file is copied from here:
# https://github.com/rlespinasse/docker-drawio-desktop-headless/blob/v1.x/src/entrypoint.sh

set -euo pipefail

if [[ "${SCRIPT_DEBUG_MODE:-false}" == "true" ]]; then
  set -x
fi

# Prepare output cleaning
touch "${DRAWIO_DESKTOP_SOURCE_FOLDER:?}/unwanted-lines.txt"
if [[ "${ELECTRON_DISABLE_SECURITY_WARNINGS:?}" == "true" ]]; then
  cat "${DRAWIO_DESKTOP_SOURCE_FOLDER:?}/unwanted-security-warnings.txt" >>"${DRAWIO_DESKTOP_SOURCE_FOLDER:?}/unwanted-lines.txt"
fi

if [[ "${DRAWIO_DISABLE_UPDATE:?}" == "true" ]]; then
  # Remove 'deb support' logs
  # since 'autoUpdater.logger.transports.file.level' is set as 'info' on drawio-desktop
  cat "${DRAWIO_DESKTOP_SOURCE_FOLDER:?}/unwanted-update-logs.txt" >>"${DRAWIO_DESKTOP_SOURCE_FOLDER:?}/unwanted-lines.txt"
fi

# Start Xvfb
export DISPLAY="${XVFB_DISPLAY:?}"
# Here is a modification to get rid of the following error:
# Fatal server error:
# ---
# (EE) Server is already active for display 42
#      If this server is no longer running, remove /tmp/.X42-lock
#      and start again.
# ---
# When running as a server, we should start X only onces...
if ! [ -f /tmp/.X42-lock ]; then
    # shellcheck disable=SC2086
    # shellcheck disable=SC2154
    Xvfb "${XVFB_DISPLAY:?}" ${XVFB_OPTIONS} &
fi

# Run

timeout "${DRAWIO_DESKTOP_COMMAND_TIMEOUT:?}" "${DRAWIO_DESKTOP_SOURCE_FOLDER:?}/runner_wrapper.sh" "$@"
