#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Artur Braga's Add-on: hafirefox
#
# Displays Firefox in a Home Assistant Addon
# ==============================================================================

# ==============================================================================
# RUN LOGIC
# ------------------------------------------------------------------------------
start_x11_vnc_server() {
    bashio::log.debug "${FUNCNAME[0]}"

    verbosity=" "
    if bashio::config.has_value 'log_level'; then
        log_level=$(bashio::config 'log_level')
        if [ "$log_level" = "debug" ] || [ "$log_level" = "info" ]; then
        verbosity="-v"
        bashio::log.info "Debug level set to either debug or info, adding $verbosity to argument list"
    fi
    
    bashio::log.info "Starting X VNC Server"
    /usr/bin/x11vnc -create -forever -nopw "$verbosity"
}
start_x11_vnc_server "$@"