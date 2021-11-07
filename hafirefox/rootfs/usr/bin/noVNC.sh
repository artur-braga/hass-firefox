#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Artur Braga's Add-on: hafirefox
#
# Displays Firefox in a Home Assistant Addon
# ==============================================================================

# ==============================================================================
# RUN LOGIC
# ------------------------------------------------------------------------------
start_noVNC() {
    bashio::log.debug "${FUNCNAME[0]}"
    
    bashio::log.info "Starting the noVNC, the HTML VNC client"
    /root/noVNC/utils/novnc_proxy --vnc localhost:5900 --listen 5800
}
start_noVNC "$@"