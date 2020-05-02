#! /bin/bash
# Adapter from https://github.com/alehander92/lodka
rm -rf build/*
set -e

nim c kernel/main.nim
i686-elf-as kernel/boot.s -o build/boot.o

cd build
files=(./*.c)
cd ..
echo $files
for file in "${files[@]}"; do
  echo $file
  i686-elf-gcc -c -w -ffreestanding -fstrength-reduce -fomit-frame-pointer -finline-functions -nostdlib -fno-builtin -m32 -g3 -gdwarf -Wall -Wextra -fno-builtin -L./c -I./c -o build/$file.o build/$file
done

mv build/boot.o /tmp
objects=(build/*.o)
mv /tmp/boot.o build/

# credit https://stackoverflow.com/questions/13470413/converting-a-bash-array-into-a-delimited-string
printf -v objects2 ' %s' "${objects[@]}"
echo $objects2
i686-elf-gcc -T kernel/linker.ld  -o build/jackos.bin -z max-page-size=0x1000 -ffreestanding -g3 -gdwarf -fno-builtin -nostdlib build/boot.o $objects2 -static-libgcc -lgcc
