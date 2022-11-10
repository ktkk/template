# Project properties
PROJECT       = foo
AUTHOR        = katkak
VERSION_MAJOR = 1
VERSION_MINOR = 0

IS_LIB        = yes
LIB_NAME      = $(PROJECT)
IS_EXE        =
EXE_NAME      =

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
LIBS  =
LIBS_STATIC = $(foreach _LIB,$(LIBS), \
				$(LIBS_DIR)/$(_LIB)/$(BUILD_DIR)/lib$(_LIB).a)

# Include flags
INCFLAGS  = -I$(INCLUDE_DIR)
INCFLAGS += $(foreach _LIB,$(LIBS), \
				-I$(LIBS_DIR)/$(_LIB)/$(INCLUDE_DIR))

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
LDFLAGS += $(foreach _LIB,$(LIBS), \
			-L$(LIBS_DIR)/$(_LIB)/$(BUILD_DIR) -l$(_LIB))
LDFLAGS += $(INCFLAGS) # append include flags

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

# Functions
define LIB_recipe =
$$(LIBS_DIR)/$(1)/$$(BUILD_DIR)/lib$(1).a: $$(LIBS_DIR)/$(1)/$$(shell make -C $$(LIBS_DIR)/$(1) print-SRCS -s)
	@tput setaf 1 ; echo -n "[MAKE] " ; tput sgr0 ; echo "Building library $(1)"
	$$(MAKE) -C $$(LIBS_DIR)/$(1)
endef

define LIB_clean =
$(MAKE) -C $(LIBS_DIR)/$(1) clean;
endef

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

$(foreach _LIB,$(LIBS),$(eval $(call LIB_recipe,$(_LIB))))

ifdef IS_EXE
$(BUILD_DIR)/$(EXE): $(OBJS) $(LIBS_STATIC) | $(BUILD_DIR)
	@tput setaf 1 ; echo -n "[LD] " ; tput sgr0 ; echo -n "Linking objects\n"
	$(LD) $(filter %.o,$^) $(LDFLAGS) -o $@
endif
ifdef IS_LIB
$(BUILD_DIR)/$(LIB): $(OBJS) | $(BUILD_DIR)
	@tput setaf 1 ; echo -n "[AR] " ; tput sgr0 ; echo -n "Archiving objects\n"
	$(AR) $(ARFLAGS) $@ $^
endif

%.o: %.cpp
	@tput setaf 1 ; echo -n "[CC] " ; tput sgr0 ; echo -n "Building sources\n"
	$(CCACHE) $(CC) -o $@ -c $< $(CCFLAGS)

clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(OBJS)
	$(foreach _LIB,$(LIBS),$(call LIB_clean,$(_LIB)))

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
