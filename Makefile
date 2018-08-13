CC = riscv32-unknown-elf-gcc
CXX = riscv32-unknown-elf-g++
LD = riscv32-unknown-elf-g++
OPENOCD = openocd
GDB = riscv32-unknown-elf-gdb

CPPFLAGS = -Iinclude -DF_CPU=16000000LL -DFREEDOM_E300_HIFIVE1

CCFLAGS = -c -O0 -march=rv32imac -fpeel-loops -ffreestanding -g \
          -ffunction-sections -fdata-sections -Wall -Werror -Wextra

CXXFLAGS = ${CCFLAGS} -fno-rtti -fno-exceptions

LDFLAGS = -T hifive1.ld -nostartfiles -Wl,-N -Wl,--gc-sections -nostdlib -Wl,--wrap=malloc -Wl,--wrap=free -Wl,--wrap=sbrk -Wl,-Map=lockbox.map

OPENOCD_ARGS = -f openocd.cfg

all: lockbox.exe


clean:
	rm -f *.o lockbox.exe lockbox.map

%.o: %.c
	${CC} ${CPPFLAGS} ${CCFLAGS} $<

%.o: %.cpp
	${CXX} ${CPPFLAGS} ${CXXFLAGS} $<

lockbox.exe: lockbox.o LiquidCrystal.o core.a
	${LD} ${LDFLAGS} lockbox.o LiquidCrystal.o -Wl,--start-group core.a -lm -lstdc++ -lc -lgloss -Wl,--end-group -lgcc -o lockbox.exe

upload: lockbox.exe
	$(OPENOCD) $(OPENOCD_ARGS) & \
            $(GDB) lockbox.exe --batch -ex "set remotetimeout 240" -ex "target extended-remote localhost:3333" -ex "monitor reset halt" -ex "monitor flash protect 0 64 last off" -ex "load" -ex "monitor resume" -ex "monitor shutdown" -ex "quit" && echo Done

run_openocd:
	$(OPENOCD) $(OPENOCD_ARGS)

run_gdb:
	$(GDB) lockbox.exe -ex "set remotetimeout 240" -ex "target extended-remote localhost:3333"

shellcode: shellcode.s shellcode.ld
	riscv32-unknown-elf-as -march=rv32imac shellcode.s -o shellcode.o
	riscv32-unknown-elf-ld -T shellcode.ld shellcode.o -o shellcode.bin -Map shellcode.map
