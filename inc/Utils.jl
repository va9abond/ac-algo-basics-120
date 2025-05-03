function send_debug_info(io, msg...)
    # println(String(take!(inspector_debug_buf))) ignore colors?
    # printstyled(io, "[DEBUG] "; color=:yellow)
    # println(io, msg)

    debug_info_prefix = "[DEBUG] "
    println(io, debug_info_prefix, msg...)
end

@inline function swap(v, i, j)
    @inbounds begin
        temp = v[i]
        v[i] = v[j]
        v[j] = temp
    end

    return nothing
end
