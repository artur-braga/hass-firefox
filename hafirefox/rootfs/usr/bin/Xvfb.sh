#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Artur Braga's Add-on: hafirefox
#
# Displays Firefox in a Home Assistant Addon
# ==============================================================================

# ==============================================================================
# RUN LOGIC
# ------------------------------------------------------------------------------
start_x_window_virtual_framebuffer() {
    bashio::log.debug "${FUNCNAME[0]}"

    width=$(bashio::config 'display_width')
    height=$(bashio::config 'display_height')

    bashio::log.info "Starting X Window Virtual Framebuffer with the size: ${width}x${height}x24"
    Xvfb :0 -screen 0 "%(ENV_DISPLAY_WIDTH)s"x"%(ENV_DISPLAY_HEIGHT)s"x24
}
start_x_window_virtual_framebuffer "$@"