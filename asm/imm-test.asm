# print out some statements about the first input value, assuming it is a number
    ori $2, $0, 0xFFFC # store output address to $2
    ori $3, $0, 0xFFF8 # store input address to $3

    lw $16, $3, 0

    addi $16, $16, -0x30

    ori $4, $0, 0x0A #\n
    jal Print
    ori $4, $0, 0x2B #+
    jal Print
    ori $4, $0, 0x35 #5
    jal Print
    ori $4, $0, 0x3A #:
    jal Print
    ori $4, $0, 0x20 #(space)
    jal Print

    addi $4, $16, 5
    addi $4, $4, 0x30
    jal Print


    ori $4, $0, 0x0A #\n
    jal Print
    ori $4, $0, 0x2B #+
    jal Print
    ori $4, $0, 0x35 #5
    jal Print
    ori $4, $0, 0x75 #u
    jal Print
    ori $4, $0, 0x3A #:
    jal Print
    ori $4, $0, 0x20 #(space)
    jal Print

    addiu $4, $16, 5
    addi $4, $4, 0x30
    jal Print


    ori $4, $0, 0x0A #\n
    jal Print
    ori $4, $0, 0x3C #<
    jal Print
    ori $4, $0, 0x35 #5
    jal Print
    ori $4, $0, 0x3F #?
    jal Print
    ori $4, $0, 0x20 #(space)
    jal Print

    ori $13, $0, 5
    slt $4, $16, $13

    beq $4, $0, 8
    add $0, $0, $0

    ori $4, $0, 0x79 #y
    jal Print
    ori $4, $0, 0x65 #e
    jal Print
    ori $4, $0, 0x73 #s
    jal Print

    j End

    ori $4, $0, 0x6E #n
    jal Print
    ori $4, $0, 0x6F #o
    jal Print
    j End

Print:
    sw  $4, $2, 0
    jr $31

End:
    ori $4, $0, 0x0A #\n
    jal Print

    halt

    ori $4, $0, 0x21 #!
    jal Print
