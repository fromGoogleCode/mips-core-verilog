.data
msg1:   .asciiz "A 17 byte message"
msg2:   .asciiz "Another message of 27 bytes"
num1:   .byte 45
num2:   .half 654
num3:   .word 0xcafebabe
num4:   .word 0xfeedface
.text
.globl main
main:
addu $s0, $ra, $0    # save return address
li $v0, 4            # syscall number for print_str
la $a0, msg1         # address of string
syscall
la $a0, msg2         # address of second string
syscall
lb $t0, num1         # t0 <- num1  (byte)
lh $t1, num2         # t1 <- num2  (half-word)
lw $t2, num3         # t2 <- num3  (word)
lw $t3, num4         # t3 <- num4  (word)
addu $ra, $s0, $0    # restore return address
jr $ra               # return from main