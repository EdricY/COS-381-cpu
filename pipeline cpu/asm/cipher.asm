# Cipher 5 characters from std-in by the amount of the first character
# If the first character is e, it should print out the next 5 characters the same
# The first value printed is the ascii equivalent to the amount of the shift.

    ori $2, $0, 0xFFFC # store output address to $2
    ori $3, $0, 0xFFF8 # store input address to $3

    lw $16, $3, 0
    lw $17, $3, 0
    lw $18, $3, 0
    lw $19, $3, 0
    lw $20, $3, 0
    lw $21, $3, 0

    addi $16, $16, -65 # $16 = $16 - 65 (A)

    add $17, $17, $16
    add $18, $18, $16
    add $19, $19, $16
    add $20, $20, $16
    add $21, $21, $16

    ori $8, $0, 0x73
    sw  $8, $2, 0
    ori $8, $0, 0x68
    sw  $8, $2, 0
    ori $8, $0, 0x69
    sw  $8, $2, 0
    ori $8, $0, 0x66
    sw  $8, $2, 0
    ori $8, $0, 0x74
    sw  $8, $2, 0
    ori $8, $0, 0x65
    sw  $8, $2, 0
    ori $8, $0, 0x64
    sw  $8, $2, 0
    ori $8, $0, 0x3A
    sw  $8, $2, 0
    ori $8, $0, 0x0A
    sw  $8, $2, 0

    sw $16, $2, 0
    sw $17, $2, 0
    sw $18, $2, 0
    sw $19, $2, 0
    sw $20, $2, 0
    sw $21, $2, 0

    ori $8, $0, 0x0A
    sw  $8, $2, 0
