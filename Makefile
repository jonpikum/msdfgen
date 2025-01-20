# pikul_two

PROJ=msdfgen

include config.mk

#echo $@ : $(@F) : $< : $^
define cc-bin-command
	$(CC) -std=c2x -c -o $@ -DNDEBUG -O0 $(CFLAGS) $(INCS) $<
endef
define cc-dbg-command
	$(CC) -std=c2x -c -o $@ -DDEBUG -g -O0 $(CFLAGS) $(INCS) $<
endef
define cxx-bin-command
	$(CXX) -std=c++23 -c -o $@ -DNDEBUG -O0 $(CXXFLAGS) $(INCS) $<
endef
define cxx-dbg-command
	$(CXX) -std=c++23 -c -o $@ -DDEBUG -g -O0 $(CXXFLAGS) $(INCS) $<
endef

DIR_OBJ=obj
DIR_BIN=bin
DIR_DBG=dbg

SRC = \
	core/Contour.cpp \
	core/DistanceMapping.cpp \
	core/EdgeHolder.cpp \
	core/MSDFErrorCorrection.cpp \
	core/Projection.cpp \
	core/Scanline.cpp \
	core/Shape.cpp \
	core/contour-combiners.cpp \
	core/edge-coloring.cpp \
	core/edge-segments.cpp \
	core/edge-selectors.cpp \
	core/equation-solver.cpp \
	core/export-svg.cpp \
	core/msdf-error-correction.cpp \
	core/msdfgen.cpp \
	core/rasterization.cpp \
	core/render-sdf.cpp \
	core/save-bmp.cpp \
	core/save-fl32.cpp \
	core/save-rgba.cpp \
	core/save-tiff.cpp \
	core/sdf-error-estimation.cpp \
	core/shape-description.cpp \

#	ext/import-font.cpp \
#	ext/import-svg.cpp \
#	ext/resolve-shape-geometry.cpp \
#	ext/save-png.cpp \

SRC_C           = $(filter %.c,$(SRC))
SRC_CXX         = $(filter %.cpp,$(SRC))
OBJ             = $(SRC_C:%.c=%.o)
SOBJ            = $(SRC_C:%.c=%.so)
CXXOBJ          = $(SRC_CXX:%.cpp=%.o)
CXXSOBJ         = $(SRC_CXX:%.cpp=%.so)
TMP_OUT_OBJ     = $(notdir $(OBJ))
TMP_OUT_SOBJ    = $(notdir $(SOBJ))
TMP_OUT_CXXOBJ  = $(notdir $(CXXOBJ))
TMP_OUT_CXXSOBJ = $(notdir $(CXXSOBJ))
OUT_OBJ         = $(TMP_OUT_OBJ:%.o=$(DIR_OBJ)/%.o)
OUT_SOBJ        = $(TMP_OUT_SOBJ:%.so=$(DIR_OBJ)/%.so)
OUT_CXXOBJ      = $(TMP_OUT_CXXOBJ:%.o=$(DIR_OBJ)/%.o)
OUT_CXXSOBJ     = $(TMP_OUT_CXXSOBJ:%.so=$(DIR_OBJ)/%.so)

.PHONY: default
default: options $(DIR_BIN)/msdfgen.a ;

.PHONY: default-dbg
default-dbg: options $(DIR_DBG)/msdfgen.a ;

.PHONY: prepare
prepare:
	mkdir -p $(DIR_BIN) $(DIR_DBG) $(DIR_OBJ)

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

%.h: ;

$(SRC_C): config.h config.mk
$(SRC_CXX): config.h config.mk

$(DIR_OBJ)/%.o : core/%.c
	$(cc-bin-command)
$(DIR_OBJ)/%.so : core/%.c
	$(cc-dbg-command)
$(DIR_OBJ)/%.o : ext/%.c
	$(cc-bin-command)
$(DIR_OBJ)/%.so : ext/%.c
	$(cc-dbg-command)

$(DIR_OBJ)/%.o : core/%.cpp
	$(cxx-bin-command)
$(DIR_OBJ)/%.so : core/%.cpp
	$(cxx-dbg-command)
$(DIR_OBJ)/%.o : ext/%.cpp
	$(cxx-bin-command)
$(DIR_OBJ)/%.so : ext/%.cpp
	$(cxx-dbg-command)

$(DIR_BIN)/msdfgen.a: prepare .WAIT $(OUT_OBJ) $(OUT_CXXOBJ)
$(DIR_BIN)/msdfgen.a:
	ar rc $@ $(filter %.o,$^)
	ranlib $@

$(DIR_DBG)/msdfgen.a: prepare .WAIT $(OUT_SOBJ) $(OUT_CXXSOBJ)
$(DIR_DBG)/msdfgen.a:
	ar rc $@ $(filter %.so,$^)
	ranlib $@

.PHONY: print
print:
	@echo $(DST_SHADERS)

.PHONY: clean
clean:
	rm -rf .cache
	rm -f *.o *.so *.plist config.h
	rm -rf $(DIR_BIN) $(DIR_OBJ) $(DIR_DBG)
