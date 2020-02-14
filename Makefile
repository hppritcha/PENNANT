BUILDDIR := build
PRODUCT := pennant

SRCDIR := src

HDRS := $(wildcard $(SRCDIR)/*.hh)
SRCS := $(wildcard $(SRCDIR)/*.cc)
OBJS := $(SRCS:$(SRCDIR)/%.cc=$(BUILDDIR)/%.o)
DEPS := $(SRCS:$(SRCDIR)/%.cc=$(BUILDDIR)/%.d)

BINARY := $(BUILDDIR)/$(PRODUCT)

# begin compiler-dependent flags
#
# gcc flags:
CXX := g++
CXXFLAGS_DEBUG := -g
CXXFLAGS_OPT := -O3 -fopt-info -march=armv8.2-a+sve -I /usr/projects/artab/protected/armie/armie/build/clients/include
#CXXFLAGS_OPENMP := -fopenmp
CXXFLAGS_OPENMP := 

# intel flags:
#CXX := icpc
#CXXFLAGS_DEBUG := -g
#CXXFLAGS_OPT := -O3 -fast -fno-alias -axCORE-AVX512
#CXXFLAGS_OPT := -O3 -fast -fno-alias -axCORE-AVX512 -qopt-report -qopt-report-phase=vec -no-ipo
#CXXFLAGS_OPT := -O3 -fast -fno-alias -axCORE-AVX2 -qopt-report -qopt-report-phase=vec -no-ipo
#CXXFLAGS_OPT := -O3 -fast -fno-alias -no-vec -no-simd
#CXXFLAGS_OPENMP := -openmp

# arm flags:
#CXX := armclang++
#CXXFLAGS_DEBUG := -g
#CXXFLAGS_OPT := -Ofast -fstrict-aliasing
#CXXFLAGS_OPT := -Ofast -fstrict-aliasing -Rpass-missed=vectorize -march=armv8-a+sve -Rpass=loop-vectorize -Rpass-analysis=loop-vectorize -fsave-optimization-record
#CXXFLAGS_OPT := -Ofast -fstrict-aliasing  -march=armv8-a+sve -Rpass=loop-vectorize -Rpass-analysis=loop-vectorize -fsave-optimization-record
#CXXFLAGS_OPT := -Ofast -fstrict-aliasing
#CXXFLAGS_OPENMP := -fopenmp
#CXXFLAGS_OPENMP :=

# arm flags:
#CXX := CC
#CXXFLAGS_DEBUG := -g
#CXXFLAGS_OPT := -Ofast -fstrict-aliasing
#CXXFLAGS_OPT := -Ofast -fstrict-aliasing -Rpass-missed=vectorize -march=armv8-a+sve -Rpass=loop-vectorize -Rpass-analysis=loop-vectorize -fsave-optimization-record
#CXXFLAGS_OPT := -Ofast -fstrict-aliasing  -march=armv8-a+sve -Rpass=loop-vectorize -Rpass-analysis=loop-vectorize -fsave-optimization-record
#CXXFLAGS_OPT := -Ofast -fstrict-aliasing
#CXXFLAGS_OPENMP := -fopenmp
#CXXFLAGS_OPENMP :=

# pgi flags:
#CXX := pgCC
#CXXFLAGS_DEBUG := -g
#CXXFLAGS_OPT := -O3 -fastsse
#CXXFLAGS_OPENMP := -mp

# CCE flags:
#CXX := CC
#CXXFLAGS_DEBUG := -g 
#CXXFLAGS_OPT := -v -O3 -hlist=a -hreport=v -hfp2 
#CXXFLAGS_OPT := -O3 -hlist=a -hreport=v -I /usr/projects/artab/protected/armie/armie/build/clients/include
#CXXFLAGS_OPENMP := -mp
# end compiler-dependent flags

# select optimized or debug
CXXFLAGS := $(CXXFLAGS_OPT)
#CXXFLAGS := $(CXXFLAGS_DEBUG)

# add mpi to compile (comment out for serial build)
# the following assumes the existence of an mpi compiler
# wrapper called mpicxx
#CXX := CC
#CXXFLAGS += -DUSE_MPI

# add openmp flags (comment out for serial build)
CXXFLAGS += $(CXXFLAGS_OPENMP)
LDFLAGS += $(CXXFLAGS_OPENMP)

LD := $(CXX)


# begin rules
all : $(BINARY)

-include $(DEPS)

$(BINARY) : $(OBJS)
	@echo linking $@
	$(maketargetdir)
	$(LD) -o $@ $^ $(LDFLAGS)

$(BUILDDIR)/%.o : $(SRCDIR)/%.cc
	@echo compiling $<
	$(maketargetdir)
	$(CXX) $(CXXFLAGS) $(CXXINCLUDES) -c -o $@ $<

$(BUILDDIR)/%.d : $(SRCDIR)/%.cc
	@echo making depends for $<
	$(maketargetdir)
	@$(CXX) $(CXXFLAGS) $(CXXINCLUDES) -MM $< | sed "1s![^ \t]\+\.o!$(@:.d=.o) $@!" >$@

define maketargetdir
	-@mkdir -p $(dir $@) >/dev/null 2>&1
endef

.PHONY : clean
clean :
	rm -f $(BINARY) $(OBJS) $(DEPS)
