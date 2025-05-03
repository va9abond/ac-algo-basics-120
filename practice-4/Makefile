COMPILER := julia
FLAGS    := \
			--threads 1 \
			--optimize=0 \
			--debug-info=2 \
			--check-bounds=auto \

default: main.jl
	$(COMPILER) $(FLAGS) main.jl
