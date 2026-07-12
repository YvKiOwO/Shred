# Shred
Shred: A pure x86_64 assembly ELF analyzer. Minimalist, dependency free, and designed for transparent binary inspection.

## Purpose
Shred provides an unfiltered view of binary headers, entry points, and section structures. It is designed for environments where dependency bloat is unacceptable and binary integrity is the priority.

## Build
Requires `nasm` and `ld`.

```bash
nasm -f elf64 shred.asm -o shred.o
ld shred.o -o shred
./shred (target binary)
```

![image](https://github.com/YvKiOwO/Shred/blob/main/2026-07-12_16-02.png)
(yes I used the OPL.elf to test. Just to test things, not to say anything bad against it. I love OPL <3)
