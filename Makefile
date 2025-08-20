# msdfgen

PROJ=msdfgen

# Automatically set BUILD_MODE if target path hints at it
ifeq (,$(BUILD_MODE))
 ifneq (,$(findstring .sa,$(MAKECMDGOALS)))
  BUILD_MODE := debug
 else ifneq (,$(findstring .rsa,$(MAKECMDGOALS)))
  BUILD_MODE := release-debug
 else ifneq (,$(findstring .a,$(MAKECMDGOALS)))
  BUILD_MODE := release
 endif
endif

include config.mk

DIR_OBJ               := obj
BUILD_MODE            ?= release

ifeq ($(BUILD_MODE),release)
 OBJ_EXT        := o
 LIB_EXT        := a
 OPT_FLAGS      ?= -O3
else ifeq ($(BUILD_MODE),release-debug)
 OBJ_EXT        := rso
 LIB_EXT        := rsa
 OPT_FLAGS      ?= -O2 -g
else ifeq ($(BUILD_MODE),debug)
 OBJ_EXT        := so
 LIB_EXT        := sa
 OPT_FLAGS      ?= -O0 -g
else
 $(error Unknown build mode: $(BUILD_MODE))
endif

define cc-command
	$(CC) -std=c2x -c -o $@ -DNDEBUG $(OPT_FLAGS) $(CFLAGS) $(INCS) $<
endef
define cxx-command
	$(CXX) -std=c++23 -c -o $@ -DDEBUG $(OPT_FLAGS) $(CXXFLAGS) $(INCS) $<
endef

SRC = \

.PHONY: default
default: options $(DIR_OBJ)/libmsdfgen.$(LIB_EXT) ;

.PHONY: prepare
prepare: config.mk
prepare:
	mkdir -p $(DIR_OBJ)

.PHONY: options
options: prepare .WAIT
	@echo "$(PROJ)" build options:
	@echo "CFLAGS   = $(CFLAGS)"
	@echo "CXXFLAGS = $(CXXFLAGS)"
	@echo "LDFLAGS  = $(LDFLAGS)"
	@echo "CC       = $(CC)"
	@echo "CXX      = $(CXX)"

config.h:
	cp config.def.h $@

$(DIR_OBJ)/%.$(OBJ_EXT) : core/%.c | prepare
	$(cc-command)
$(DIR_OBJ)/%.$(OBJ_EXT) : ext/%.c | prepare
	$(cc-command)

$(DIR_OBJ)/%.$(OBJ_EXT) : core/%.cpp | prepare
	$(cxx-command)
$(DIR_OBJ)/%.$(OBJ_EXT) : ext/%.cpp | prepare
	$(cxx-command)

$(DIR_OBJ)/libmsdfgen.$(LIB_EXT): $(DIR_OBJ)/Contour.$(OBJ_EXT)
$(DIR_OBJ)/libmsdfgen.$(LIB_EXT): $(DIR_OBJ)/DistanceMapping.$(OBJ_EXT)
$(DIR_OBJ)/libmsdfgen.$(LIB_EXT): $(DIR_OBJ)/EdgeHolder.$(OBJ_EXT)
$(DIR_OBJ)/libmsdfgen.$(LIB_EXT): $(DIR_OBJ)/MSDFErrorCorrection.$(OBJ_EXT)
$(DIR_OBJ)/libmsdfgen.$(LIB_EXT): $(DIR_OBJ)/Projection.$(OBJ_EXT)
$(DIR_OBJ)/libmsdfgen.$(LIB_EXT): $(DIR_OBJ)/Scanline.$(OBJ_EXT)
$(DIR_OBJ)/libmsdfgen.$(LIB_EXT): $(DIR_OBJ)/Shape.$(OBJ_EXT)
$(DIR_OBJ)/libmsdfgen.$(LIB_EXT): $(DIR_OBJ)/contour-combiners.$(OBJ_EXT)
$(DIR_OBJ)/libmsdfgen.$(LIB_EXT): $(DIR_OBJ)/convergent-curve-ordering.$(OBJ_EXT)
$(DIR_OBJ)/libmsdfgen.$(LIB_EXT): $(DIR_OBJ)/edge-coloring.$(OBJ_EXT)
$(DIR_OBJ)/libmsdfgen.$(LIB_EXT): $(DIR_OBJ)/edge-segments.$(OBJ_EXT)
$(DIR_OBJ)/libmsdfgen.$(LIB_EXT): $(DIR_OBJ)/edge-selectors.$(OBJ_EXT)
$(DIR_OBJ)/libmsdfgen.$(LIB_EXT): $(DIR_OBJ)/equation-solver.$(OBJ_EXT)
$(DIR_OBJ)/libmsdfgen.$(LIB_EXT): $(DIR_OBJ)/export-svg.$(OBJ_EXT)
$(DIR_OBJ)/libmsdfgen.$(LIB_EXT): $(DIR_OBJ)/msdf-error-correction.$(OBJ_EXT)
$(DIR_OBJ)/libmsdfgen.$(LIB_EXT): $(DIR_OBJ)/msdfgen.$(OBJ_EXT)
$(DIR_OBJ)/libmsdfgen.$(LIB_EXT): $(DIR_OBJ)/rasterization.$(OBJ_EXT)
$(DIR_OBJ)/libmsdfgen.$(LIB_EXT): $(DIR_OBJ)/render-sdf.$(OBJ_EXT)
$(DIR_OBJ)/libmsdfgen.$(LIB_EXT): $(DIR_OBJ)/save-bmp.$(OBJ_EXT)
$(DIR_OBJ)/libmsdfgen.$(LIB_EXT): $(DIR_OBJ)/save-fl32.$(OBJ_EXT)
$(DIR_OBJ)/libmsdfgen.$(LIB_EXT): $(DIR_OBJ)/save-rgba.$(OBJ_EXT)
$(DIR_OBJ)/libmsdfgen.$(LIB_EXT): $(DIR_OBJ)/save-tiff.$(OBJ_EXT)
$(DIR_OBJ)/libmsdfgen.$(LIB_EXT): $(DIR_OBJ)/sdf-error-estimation.$(OBJ_EXT)
$(DIR_OBJ)/libmsdfgen.$(LIB_EXT): $(DIR_OBJ)/shape-description.$(OBJ_EXT)
$(DIR_OBJ)/libmsdfgen.$(LIB_EXT): $(DIR_OBJ)/import-font.$(OBJ_EXT)
$(DIR_OBJ)/libmsdfgen.$(LIB_EXT): $(DIR_OBJ)/import-svg.$(OBJ_EXT)
$(DIR_OBJ)/libmsdfgen.$(LIB_EXT): $(DIR_OBJ)/resolve-shape-geometry.$(OBJ_EXT)
$(DIR_OBJ)/libmsdfgen.$(LIB_EXT): $(DIR_OBJ)/save-png.$(OBJ_EXT)
$(DIR_OBJ)/libmsdfgen.$(LIB_EXT):
	ar rc $@ $(filter %.$(OBJ_EXT),$^)
	ranlib $@

.PHONY: clean
clean:
	rm -rf .cache
	rm -f *.o *.so *.plist config.h
	rm -rf $(DIR_OBJ)
