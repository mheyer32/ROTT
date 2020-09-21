#game variants

SHAREWARE ?=0
SUPERROTT ?=0
SITELICENSE ?=0

DEBUG ?= 0
BINDIR ?= bin
USEIXEMUL ?= 1
PROFILE  ?= 0

CC := m68k-amigaos-gcc
STRIP := m68k-amigaos-strip
PHXASS := vasmm68k_mot

PREFIX = $(shell ./getprefix.sh "$(CC)")

#-Wstrict-prototypes
CFLAGS += -m68030 -s -msmall-code -mregparm=4 -noixemul
CFLAGS += -Werror -Wimplicit -Wdouble-promotion -fstrict-aliasing

LDFLAGS = -noixemul -s

#Always	provide symbols, will be stripped away  for target executable
CFLAGS += -g -ggdb
LDFLAGS += -g -ggdb

ifeq ($(DEBUG), 1)
	CFLAGS += -DDEBUG=1 -Og -ffast-math -fno-omit-frame-pointer
	#-DRANGECHECK
else
	CFLAGS += -DNDEBUG -DDEBUG=0 -Os -fstrength-reduce -ffast-math -fexpensive-optimizations
	ifeq ($(PROFILE), 0)
		CFLAGS +=-fomit-frame-pointer
	endif
endif

ifeq ($(PROFILE), 1)
	CFLAGS += -pg
	LDFLAGS += -pg
endif

CFLAGS += -DMAX_PATH=256 -DSDL_BYTEORDER=SDL_BIG_ENDIAN -DPLATFORM_UNIX=1 -DAMIGA -DSHAREWARE=$(SHAREWARE) -DSUPERROTT=$(SUPERROTT) -DSITELICENSE=$(SITELICENSE)

PFLAGS = -Fhunk -phxass -nosym -ldots -m68030 -linedebug
PFLAGS += -I$(PREFIX)/m68k-amigaos/ndk-include
PFLAGS += -I$(PREFIX)/m68k-amigaos/ndk/include

SRC_FILES := rott/byteordr.c \
			rott/cin_actr.c \
			rott/cin_efct.c \
			rott/cin_evnt.c \
			rott/cin_glob.c \
			rott/cin_main.c \
			rott/cin_util.c \
			rott/engine.c \
			rott/isr.c \
			rott/modexlib.c \
			rott/rt_actor.c \
			rott/rt_battl.c \
			rott/rt_build.c \
			rott/rt_cfg.c \
			rott/rt_com.c \
			rott/rt_crc.c \
			rott/rt_debug.c \
			rott/rt_dmand.c \
			rott/rt_door.c \
			rott/rt_draw.c \
			rott/rt_err.c \
			rott/rt_floor.c \
			rott/rt_game.c \
			rott/rt_in.c \
			rott/rt_main.c \
			rott/rt_map.c \
			rott/rt_menu.c \
			rott/rt_msg.c \
			rott/rt_net.c \
			rott/rt_playr.c \
			rott/rt_rand.c \
			rott/rt_scale.c \
			rott/rt_sound.c \
			rott/rt_spbal.c \
			rott/rt_sqrt.c \
			rott/rt_stat.c \
			rott/rt_state.c \
			rott/rt_str.c \
			rott/rt_swift.c \
			rott/rt_ted.c \
			rott/rt_vid.c \
			rott/rt_view.c \
			rott/scriplib.c \
			rott/w_wad.c \
			rott/z_zone.c \
			rott/i_timer.c \
			rott/fx_man.c \
			rott/amiga_median.c \
			rott/winrott.c \
			rott/rt_util.c \
			rott/dosutil.c \
			rott/watcom.c

all: ROTT.exe | Makefile

OBJ_FILES :=

define make_dependency
  ${1} : ${2} | Makefile
  OBJ_FILES += ${1}
endef
# build dependencies between the .c and .o files
$(foreach in,${SRC_FILES},$(eval $(call make_dependency,$(patsubst %.c,obj/%.o,${in}),${in})))

#$(info $(OBJ_FILES))
$(shell mkdir -p obj/rott/audiolib)

clean :
	rm -f ROTT.exe
	rm -rf obj

ROTT.exe: $(OBJ_FILES) | Makefile
	$(CC) -v $(CFLAGS) $(LDFLAGS) -o $@ $^ \
		rott/c2p1x1_6_c5_bm_040.o \
		rott/c2p1x1_6_c5_bm.o \
		rott/c2p1x1_8_c5_bm_040.o  \
		rott/c2p1x1_8_c5_bm.o  \
		rott/indivision.o \
		rott/m_mmu.o
	$(STRIP) --strip-debug --strip-unneeded --strip-all $@ -o $(BINDIR)/$@

$(OBJ_FILES): % : | Makefile
	$(CC) $(CFLAGS) -c $< -o $@


