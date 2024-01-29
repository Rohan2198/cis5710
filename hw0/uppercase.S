.section .data
input_string: .asciz "Hello world!"

.align 8
tohost: .byte 0
.align 8
fromhost: .byte 0

.section .text
.globl _start
_start:
    la a0, input_string      # Load the address of the input string into a0

    # Load ASCII values for 'a' and 'z' into registers
    li t1, 97                # ASCII value for 'a'
    li t2, 122               # ASCII value for 'z'

l1:
    lb t0, 0(a0)             # Load the byte at a0 into t0
    beqz t0, end_program     # If the byte is zero (NUL), jump to end_program
    blt t0, t1, l2         # If the byte is less than 'a', l2 conversion
    bgt t0, t2, l2         # If the byte is greater than 'z', l2 conversion

    # Conversion logic
    li t3, 32                # Load the value 32 into t3
    sub t0, t0, t3           # Subtract 32 from the character
    sb t0, 0(a0)             # Store the converted byte back to the memory

l2:
    addi a0, a0, 1           # Move to the next character in the string
    j l1           # Jump back to the beginning of the loop

end_program:
    j end_program            # Infinite loop