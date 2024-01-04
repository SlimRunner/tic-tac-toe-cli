ifeq ($(OS),Windows_NT)
	detected_OS := Windows
else
	detected_OS := $(shell sh -c 'uname 2>/dev/null || echo Unknown')
endif

ifeq ($(detected_OS),Windows)
	RM = del /Q /S
	FixPath = $(subst /,\,$1)
	MD = if not exist $1 mkdir $1
endif
ifeq ($(detected_OS),Linux)
	RM = rm -rf
 	FixPath = $1
	MD = mkdir -p $1
endif

CXX         := g++
CXXVERSION  := -std=c++17
CXXSTRICT   := -pedantic-errors -Werror
CXXWARN     := -Wall -Wextra -Wshadow -Wsign-conversion
CXXFLAGS    := $(CXXVERSION) $(CXXWARN) $(CXXSTRICT)
DEBUG_DIR   := ./build/debug
RELEASE_DIR := ./build/release
DBG_OBJ_DIR := $(DEBUG_DIR)/objects
DBG_APP_DIR := $(DEBUG_DIR)/app
REL_OBJ_DIR := $(RELEASE_DIR)/objects
REL_APP_DIR := $(RELEASE_DIR)/app
TARGET      := tictactoe_cli
INCLUDE     := -I include/
SRC         :=                  \
	$(wildcard src/*.cpp)         \

REL_OBJECTS      := $(SRC:%.cpp=$(REL_OBJ_DIR)/%.o)
REL_DEPENDENCIES := $(REL_OBJECTS:.o=.d)

DBG_OBJECTS      :=  $(SRC:%.cpp=$(DBG_OBJ_DIR)/%.o)
DBG_DEPENDENCIES := $(DBG_OBJECTS:.o=.d)

# default build
all: release

# release objects
$(REL_OBJ_DIR)/%.o: %.cpp
	$(call MD,$(call FixPath,$(@D)))
	$(CXX) $(CXXFLAGS) $(INCLUDE) -c $< -MMD -o $@

# release binary
$(REL_APP_DIR)/$(TARGET): $(REL_OBJECTS)
	$(call MD,$(call FixPath,$(@D)))
	$(CXX) $(CXXFLAGS) -o $(REL_APP_DIR)/$(TARGET) $^

# debug objects
$(DBG_OBJ_DIR)/%.o: %.cpp
	$(call MD,$(call FixPath,$(@D)))
	$(CXX) $(CXXFLAGS) $(INCLUDE) -c $< -MMD -o $@

# debug binary
$(DBG_APP_DIR)/$(TARGET): $(DBG_OBJECTS)
	$(call MD,$(call FixPath,$(@D)))
	$(CXX) $(CXXFLAGS) -o $(DBG_APP_DIR)/$(TARGET) $^

# only needed if more makefiles are added to this project
# -include $(REL_DEPENDENCIES)

# do not interpret these names as files
.PHONY:
	all build clean release info
	build-debug clean-debug debug info-debug

build:
	$(call MD,$(call FixPath,$(REL_APP_DIR)))
	$(call MD,$(call FixPath,$(REL_OBJ_DIR)))

build-debug:
	$(call MD,$(call FixPath,$(DBG_APP_DIR)))
	$(call MD,$(call FixPath,$(DBG_OBJ_DIR)))

debug: CXXFLAGS += -g
debug: build-debug $(DBG_APP_DIR)/$(TARGET)

release: CXXFLAGS += -O2
release: build $(REL_APP_DIR)/$(TARGET)

clean:
	$(RM) $(call FixPath,$(DBG_OBJ_DIR)/*)
	$(RM) $(call FixPath,$(DBG_APP_DIR)/*)

clean-debug:
	$(RM) $(call FixPath,$(DBG_OBJ_DIR)/*)
	$(RM) $(call FixPath,$(DBG_APP_DIR)/*)

info:
	@echo "[*] Application dir: ${REL_APP_DIR}"
	@echo "[*] Objects dir:     ${REL_OBJ_DIR}"
	@echo "[*] Sources:         ${SRC}"
	@echo "[*] Objects:         ${REL_OBJECTS}"
	@echo "[*] Dependencies:    ${REL_DEPENDENCIES}"
	@echo "[*] Detected OS:     ${detected_OS}"

info-debug:
	@echo "Debug Information"
	@echo "[*] Application dir: ${DBG_APP_DIR}"
	@echo "[*] Objects dir:     ${DBG_OBJ_DIR}"
	@echo "[*] Sources:         ${SRC}"
	@echo "[*] Objects:         ${DBG_OBJECTS}"
	@echo "[*] Dependencies:    ${DBG_DEPENDENCIES}"
	@echo "[*] Detected OS:     ${detected_OS}"
