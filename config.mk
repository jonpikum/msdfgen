# paths
PREFIX = /usr/local
MANPREFIX = $(PREFIX)/share/man

# exes
PKG_CONFIG = pkg-config

# includes and libs
USED_LIBS = \
	freetype2 \
	libpng \
	tinyxml2 \

INCS = `$(PKG_CONFIG) --cflags $(USED_LIBS)`

LIBS = -lm -lpthread `$(PKG_CONFIG) --libs $(USED_LIBS)`

# flags
SHARED_FLAGS = -D_DEFAULT_SOURCE \
	-D_POSIX_C_SOURCE=200809L \
	-DMSDFGEN_USE_LIBPNG \
	-DMSDFGEN_USE_TINYXML2 \
	-Wall \
	-Wextra \
	-pedantic \
	-fPIC \

#	-fPIC \
#	-pthread \

CFLAGS   += $(SHARED_FLAGS)
CXXFLAGS += $(SHARED_FLAGS)
CPPFLAGS = $(SHARED_FLAGS)
LDFLAGS  = $(LIBS)

# compiler & linker
CC  = /usr/bin/gcc
CXX = /usr/bin/g++
