#= Description
    A mini-library responsible for generating structures filled with
    pseudorandom values based on 'Xoshiro256++' alghoritm.

    - https://docs.julialang.org/en/v1/stdlib/Random/
    - https://prng.di.unimi.it/
=============#
using Random


# generate vector of size 'count' with random numbers of type 'type'
function generate_vector_rand(
        seed::Union{Int, String}, # if 0, then new vals will be generated on every use
        type::DataType,
        count
    )
    RNG = Xoshiro(seed)
    return rand(RNG, type, count)
end


# generate vector of size 'count' with random Int numbers in range
function generate_vector_rand(
        seed::Union{Int, String}, # if 0, then new vals will be generated on every use
        range::UnitRange,
        count
    )
    RNG = Xoshiro(seed)
    return rand(RNG, range, count)
end


function fill_vector_rand!(
        seed::Union{Int, String}, # if 0, then new vals will be generated on every use
        vector,
        type=eltype(vector),
    )
    RNG = Xoshiro(seed)
    rand!(RNG, vector, type)
end


function generate_bitvector_rand(seed, count)
    RNG = Xoshiro(seed)
    return bitrand(RNG, count)
end
