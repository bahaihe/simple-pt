USER_CFLAGS := -g -Wall
LIBIPT_LIB := ../processor-trace/lib
LIBIPT_INCLUDE := ../processor-trace/libipt/include

USER_OBJS := sptdump.o map.o fastdecode.o sptdecode.o dumpkcore.o \
	     elf.o symtab.o freq.o dtools.o kernel.o ptfeature.o
USER_EXE := sptdump fastdecode sptdecode ptfeature # dumpkcore

KDIR = /lib/modules/`uname -r`/build
obj-m := simple-pt.o
M := make -C ${KDIR} M=`pwd`

CFLAGS_simple-pt.o := -DTRACE_INCLUDE_PATH=${M}

all:
	${M} modules

install:
	${M} modules_install

clean:
	${M} clean
	rm -rf ${USER_EXE} ${USER_OBJS} loop stest.*

${USER_OBJS}: CFLAGS := ${USER_CFLAGS}

user: ${USER_EXE}

sptdump: sptdump.o
sptdump.o: sptdump.c simple-pt.h map.h
map.o: map.c map.h

fastdecode: fastdecode.o map.o

sptdecode.o: CFLAGS += -I ${LIBIPT_INCLUDE}
elf.o: CFLAGS += -I ${LIBIPT_INCLUDE}
dtools.o: CFLAGS += -I ${LIBIPT_INCLUDE}
kernel.o: CFLAGS += -I ${LIBIPT_INCLUDE}
sptdecode: LDFLAGS := -L ${LIBIPT_LIB}
sptdecode: LDLIBS := -lipt -lelf
sptdecode: sptdecode.o map.o elf.o symtab.o freq.o dtools.o kernel.o

dumpkcore: LDLIBS += -lelf
