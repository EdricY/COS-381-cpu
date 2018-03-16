# print "Hello, World!"

    ori $2, $0, 0xFFFC # store output address to $2

    ori $8, $0, 0x48
    ori $9, $0, 0x65
    ori $10, $0, 0x6C
    ori $11, $0, 0x6C
    ori $12, $0, 0x6F
    ori $13, $0, 0x2C
    ori $14, $0, 0x20
    ori $15, $0, 0x57
    ori $16, $0, 0x6F
    ori $17, $0, 0x72
    ori $18, $0, 0x6C
    ori $19, $0, 0x64
    ori $20, $0, 0x21
    ori $21, $0, 0x0A

    sw $8, $2, 0 # print $8 to screen
    sw $9, $2, 0
    sw $10, $2, 0
    sw $11, $2, 0
    sw $12, $2, 0
    sw $13, $2, 0
    sw $14, $2, 0
    sw $15, $2, 0
    sw $16, $2, 0
    sw $17, $2, 0
    sw $18, $2, 0
    sw $19, $2, 0
    sw $20, $2, 0
    sw $21, $2, 0
    halt
    sw $20, $2, 0 # should not print another '!'
