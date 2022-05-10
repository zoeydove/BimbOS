all: clean build

test: all
	qemu-system-x86_64 -cdrom out/bimbos.iso -m 4G -smp 4 -cpu host -enable-kvm -vga virtio -display sdl,gl=on -monitor stdio

clean:
	-rm -rf out/*

build:
	-mkdir /tmp/work
	sudo ../archiso/archiso/mkarchiso -v -w /tmp/work -o out/ ./profile/
	rm -rf /tmp/work