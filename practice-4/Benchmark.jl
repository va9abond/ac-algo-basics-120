# function run(
#         sorter::Function,
#         sorter_name::String="Sort"
#     ) where T
#
#     println("= $(sorter_name) = ")
#
#     for size in TEST_SIZES
#         println("Test size: $(size)")
#
#         seq = generate_vector_rand(0, -10000:10000, size)
#         time, memory, allocs = benchmark(sorter(seq))
#
#         # print("Is sorted: ")
#         # if (issorted(seq))
#         #     printstyled("YES"; color=:green)
#         # else
#         # !sorted && printstyled("NO "; color=:red)
#         # end
#         # println()
#         #
#         # print("Elapsed time: ")
#         # printstyled("$(time)"; color=:yellow)
#         # println()
#         #
#         # print("Allocations: ")
#         # printstyled("$(allocs)"; color=:yellow)
#         # println()
#     end
# end

macro xmemory(expr::Expr)
    return quote
        gc_start = Base.gc_num()

        $(esc(expr))

        gcdiff = Base.GC_Diff(Base.gc_num(), gc_start)
        memory = gcdiff.allocd
        allocs = Base.gc_alloc_count(gcdiff)

        printstyled("@memory"; color=:red)
        print(" Allocated ")
        printstyled(memory; color=:yellow)
        print(" bytes in ")
        printstyled(allocs; color=:yellow)
        println(" allocs")
    end
end

macro xbenchmark(expr::Expr)
    return quote
        gc_start = Base.gc_num()
        time_start = Base.time()

        $(esc(expr))

        time = Base.time() - time_start
        gcdiff = Base.GC_Diff(Base.gc_num(), gc_start)
        # gctime = gcdiff.total_time
        memory = gcdiff.allocd
        allocs = Base.gc_alloc_count(gcdiff)

        printstyled("@benchmark"; color=:red)
        print(" time ")
        printstyled(time; color=:yellow)
        # print(", gctime ")
        # printstyled(gctime; color=:yellow)
        print(", memory ")
        printstyled(memory; color=:yellow)
        print(", allocs ")
        printstyled(allocs; color=:yellow)
        println()
    end
end

function xbenchmark(expr::Expr)
    quote
        gc_start = Base.gc_num()
        time_start = Base.time()

        $(esc(expr))

        time = Base.time() - time_start
        gcdiff = Base.GC_Diff(Base.gc_num(), gc_start)
        memory = gcdiff.allocd
        allocs = Base.gc_alloc_count(gcdiff)
    end

    return time, memory, allocs
end
