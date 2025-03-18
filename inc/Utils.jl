function send_debug_info(io, msg::String)
    # println(String(take!(inspector_debug_buf))) ignore colors?
    # printstyled(io, "[DEBUG] "; color=:yellow)
    # println(io, msg)

    debug_info_prefix = "[DEBUG] "
    println(io, debug_info_prefix, msg)
end
