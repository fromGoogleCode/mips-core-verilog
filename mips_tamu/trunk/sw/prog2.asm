.data
msg1:    .asciiz "Please enter an integer number: "
msg2:    .asciiz "\tFirst result: "
msg3:    .asciiz "\tSecond result: "
.text
.globl main
main:
addu $s0, $ra, $0    #save return address, ra
li $v0, 4            # system call for print_str
la $a0, msg1         # address of string to print
syscall
# get user input
li $v0, 5            # system call # for read_int
syscall              # input placed in $v0

# do computation on input
addu $t0, $v0, $0    # copy input to register $t0

sll $t1, $t0, 2      # shift left logical, store into $t1
srl $t2, $t0, 2      # shift right logical, store into $t2

#print results
li $v0, 4             # system call number for print_str
la $a0, msg2          # address of string
syscall
li $v0, 1             # system call for print_int
addu $a0, $t1, $0     # copy int to a0
syscall

li $v0, 4             # system call number for print_str
la $a0, msg3          # address of string
syscall
li $v0, 1             # system call number for print_int
addu $a0, $t2, $0     # copy int to a0
syscall

addu $ra, $0, $s0     # restore return address
jr $ra                # return from main