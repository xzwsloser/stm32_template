TARGET = main
CC = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy
RM = rm -f
CORE = 3
CPUFLAGS = -mthumb -mcpu=cortex-m$(CORE)
LDFLAGS = -T stm32_flash.ld -Wl,-cref,-u,Reset_Handler -Wl,-Map=$(TARGET).map -Wl,--gc-sections -Wl,--defsym=malloc_getpagesize_P=0x80 -Wl,--start-group -lc -lm -Wl,--end-group

INCFLAGS = -I $(PWD)/cmsis -I $(PWD)/libraries/inc -I $(PWD)/user
C_SRC = $(shell find ./ -name '*.c')
C_OBJ = $(C_SRC:%.c=%.o)
START_SRC = ./startup/startup_stm32f10x_md.s
START_OBJ = $(START_SRC:%.s=%.o)

INTERFACE_CFG=/usr/share/openocd/scripts/interface/stlink.cfg
TARGET_CFG=/usr/share/openocd/scripts/target/stm32f1x.cfg

all: $(TARGET)

$(TARGET): $(START_OBJ) $(C_OBJ)
	$(CC) $(CPUFLAGS) $(LDFLAGS) $(START_OBJ) $(C_OBJ) -o $(TARGET).elf
	$(OBJCOPY) $(TARGET).elf $(TARGET).bin
	$(OBJCOPY) $(TARGET).elf -Oihex $(TARGET).hex

%.o: %.c
	$(CC) -c $(CPUFLAGS) $(INCFLAGS) -D STM32F10X_MD -D USE_STDPERIPH_DRIVER -Wall -g $< -o $@

%.o: %.s
	$(CC) -c $(CPUFLAGS) $< -o $@

clean:
	$(RM) $(shell find ./ -name '*.o') $(TARGET).*

download:
	openocd -f $(INTERFACE_CFG) -f $(TARGET_CFG) -c init -c halt -c "flash write_image erase $(PWD)/$(TARGET).bin" -c reset -c shutdown