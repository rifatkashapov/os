make_boot:
	nasm -f bin boot.asm -o boot.bin

start_boot: make_boot
	qemu-system-x86_64 boot.bin