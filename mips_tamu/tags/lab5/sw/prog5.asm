.data
msg1:  .asciiz "Enter the first number\n"
msg2:  .asciiz "Enter the second number\n"
msg:   .asciiz "The product is "
.text
.globl main
.globl my_mul
main:
     addi $sp, $sp, -8   #make room for $ra and $fp on the stack
     sw $ra, 4($sp)      # push $ra
     sw $fp, 0($sp)      # push $fp
     
     la $a0, msg1        # load address of msg1 into $a0
     li $v0, 4           # syscall number for print_str
     syscall
     li $v0, 5           # syscall for read_int
     syscall
     add $t0, $v0, $0    # store first number into $t0
     la $a0, msg2        # load address of second string
     li $v0, 4           # syscall number for print_str
     syscall
     li $v0, 5           # syscall number for read_int
     syscall
     add $a1, $v0, $0    # store second number into $a1
     add $a0, $t0, $0    # store second number into $a0
     add $fp, $sp, $0    # set fp to top of stack print to function call
     
     jal my_mul          # perform multiply, store result in $v0
     add $t0, $v0, $0    # save result to $t0
     la $a0, msg         # load third string address
     li $v0, 4           # syscall for print_str
     syscall
     add $a0, $t0, $0    # put result into $a0
     li $v0, 1           # syscall for print_int
     syscall
     
     lw $fp, 0($sp)      # restore $fp
     lw $ra, 4($sp)      # restore $ra
     addi $sp, $sp, 8    # free space
     jr $ra              # return from main
     
my_mul:
     addi $sp, $sp, -4   # make room for $s0 on the stack
     sw $s0, 0($sp)      # push $s0
     add $s0, $a1, $0    # $s0 <- $a1
     add $v0, $0, $0     # $v0 <- 0
mult_loop:
     beq $s0, $0, mult_eol
     
     add $v0, $v0, $a0
     addi $s0, $s0, -1
     j mult_loop
mult_eol:
     lw $s0, 0($sp)       # pop $s0
     jr $ra               # return from main
     
     
     
     
     
     