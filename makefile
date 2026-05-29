# make_boot:
# 	nasm -f bin boot_sect_main.asm -o boot.bin

# make_boot:
# 	cd protect_mode && nasm -f bin 32bit-main.asm -o boot.bin

# start_boot: make_boot
# 	qemu-system-x86_64 -drive file=protect_mode/boot.bin,format=raw

make_boot:
	cd protect_mode && nasm -f bin 32bit-main.asm -o boot.bin

start_boot: make_boot
	qemu-system-x86_64 -drive file=protect_mode/boot.bin,format=raw

start_os:
	qemu-system-x86_64 -kernel kernel.bi