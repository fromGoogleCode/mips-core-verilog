.data
hextable:   .asciiz "0123456789abcdef"
msg1:       .asciiz "Your number in Hex is : "
.text
.globl main
main:
addu $s0, $0, $ra      # save return address
li $v0, 5              # syscall number for read_int
syscall
add $s1, $v0, $0       # copy input to s1
li $v0, 4              # syscall number for print_str
la $a0, msg1 
syscall
la $a1, hextable
srl $t0, $s1, 4        # get upper 4 bits (to find A in 0xAB)
add $a2, $a1, $t0      # find index into hextable
lb $a0, 0($a2)         # load character from hextable
li $v0, 11             # syscall number for print_char
syscall
andi $t0, $s1, 0xf     # get lower 4 bits (to find B in 0xAB)
add $a2, $a1, $t0      # get address in hextable
lb $a0, 0($a2)         # get character
li $v0, 11             # system call for print_str
syscall
addu $ra, $s0, $0      # retore return address
jr $ra                 # return from main