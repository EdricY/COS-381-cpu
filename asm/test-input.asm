# print first 5 characters from std-in
    ori $2, $0, 0xFFFC # store output address to $2
    ori $3, $0, 0xFFF8 # store input address to $3
    lw $16, $3, 0
    lw $17, $3, 0
    lw $18, $3, 0
    lw $19, $3, 0
    lw $20, $3, 0

    sw $16, $2, 0
    sw $17, $2, 0
    sw $18, $2, 0
    sw $19, $2, 0
    sw $20, $2, 0

    ori $4, $0, 0x0A #\n
    sw  $4, $2, 0

    halt
