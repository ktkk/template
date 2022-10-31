# Project properties
PROJECT       = template
AUTHOR        = katkak
VERSION_MAJOR = 1
VERSION_MINOR = 0

IS_LIB        =
LIB_NAME      =
IS_EXE        = yes
EXE_NAME      = $(PROJECT)

ifdef IS_LIB
    LIB       = lib$(LIB_NAME).a
endif

ifdef IS_EXE
    EXE       = $(EXE_NAME)
endif

# Tools
CC = clang
LD = clang
AR = ar

# Utilities
print-%: ; @echo $($*) # Print variables

# Standard file structure
# A project structure like this is expected:
#
# |
# +- docs/
# +- libs/
# |  |
# |  +- foo/
# |     |
# |     +- docs/
# |     +- libs/
# |     +- include/
# |     +- src/
# |     +- test/
# |     +- Makefile
# +- include/
# +- src/
# +- test/
# +- Makefile
SRC_DIR     = src
LIBS_DIR    = libs
TEST_DIR    = test
DOCS_DIR    = docs
BUILD_DIR   = build
INCLUDE_DIR = include

# Libraries
# TODO: Make libraries more generic
FOO = foo
BAR = bar
LIBS_FOO = $(LIBS_DIR)/$(FOO)
LIBS_BAR = $(LIBS_DIR)/$(BAR)

# Include flags
INCFLAGS  = -I$(INCLUDE_DIR)
# TODO: Make libraries more generic
INCFLAGS += -I$(LIBS_FOO)/$(INCLUDE_DIR)
INCFLAGS += -I$(LIBS_BAR)/$(INCLUDE_DIR)

# Compiler flags
CCFLAGS  = -std=c++20
CCFLAGS += -O2
CCFLAGS += -Wall
CCFLAGS += -Wpedantic
CCFLAGS += -DVERSION_MAJOR=$(VERSION_MAJOR)
CCFLAGS += -DVERSION_MINOR=$(VERSION_MINOR)
CCFLAGS += $(INCFLAGS) # append include flags

# Linker flags
LDFLAGS  = -lm
LDFLAGS += -lstdc++
LDFLAGS += $(INCFLAGS) # append include flags
# TODO: Make libraries more generic
LDFLAGS += $(LIBS_DIR)/foo/$(BUILD_DIR)/lib$(FOO).a
LDFLAGS += $(LIBS_DIR)/bar/$(BUILD_DIR)/lib$(BAR).a

# Archiver flags
ARFLAGS = rcs

# OS specific
UNAME = $(shell uname -s)

ifeq ($(UNAME), Darwin)
    # TODO
endif

ifeq ($(UNAME), Linux)
    # TODO
endif

SRCS = $(shell find $(SRC_DIR) -name "*.cpp")
OBJS = $(SRCS:.cpp=.o)

.PHONY: clean run clangd

ifdef IS_EXE
all: $(BUILD_DIR)/$(EXE)
endif
ifdef IS_LIB
all: $(BUILD_DIR)/$(LIB)
endif

$(BUILD_DIR):
	@tput setaf 1 ; echo -n "[MKDIR] " ; tput sgr0 ; echo -n "Creating $(BUILD_DIR)\n"
	mkdir -p $(BUILD_DIR)

$(LIBS_DIR)/*/$(BUILD_DIR)/*.a:
	@tput setaf 1 ; echo -n "[MAKE] " ; tput sgr0 ; echo -n "Building libs\n"
	# TODO: Make libraries more generic
	$(MAKE) -C $(LIBS_FOO)
	$(MAKE) -C $(LIBS_BAR)

ifdef IS_EXE
$(BUILD_DIR)/$(EXE): $(OBJS) | $(BUILD_DIR) $(LIBS_DIR)/*/$(BUILD_DIR)/*.a
	@tput setaf 1 ; echo -n "[LD] " ; tput sgr0 ; echo -n "Linking objects\n"
	$(LD) $(LDFLAGS) $(filter %.o,$^) -o $@
endif
ifdef IS_LIB
$(BUILD_DIR)/$(LIB): $(OBJS) | $(BUILD_DIR) $(LIBS_DIR)/*/$(BUILD_DIR)/*.a
	@tput setaf 1 ; echo -n "[AR] " ; tput sgr0 ; echo -n "Archiving objects\n"
	$(AR) $(ARFLAGS) $@ $(filter %.o,$^)
endif

%.o: %.cpp
	@tput setaf 1 ; echo -n "[CC] " ; tput sgr0 ; echo -n "Building sources\n"
	$(CC) -o $@ -c $< $(CCFLAGS)

clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(OBJS)
	# TODO: Make libraries more generic
	$(MAKE) -C $(LIBS_FOO) clean
	$(MAKE) -C $(LIBS_BAR) clean

ifdef IS_EXE
run: $(BUILD_DIR)/$(EXE)
	./$<
endif
ifdef IS_LIB
run:
	@echo -n "Not an executable, exiting\n"
endif

clangd: clean
	bear -- make