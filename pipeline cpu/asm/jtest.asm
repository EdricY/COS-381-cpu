# jump around "Hello, World!"

    ori $2, $0, 0xFFFC # store output address to $2
    ori $8, $0, 0x48  # H
    ori $9, $0, 0x65  # e
    ori $10, $0, 0x6C # l
    ori $11, $0, 0x6C # l
    ori $12, $0, 0x6F # o
    ori $13, $0, 0x2C # ,
    ori $14, $0, 0x20 # (space)
    ori $15, $0, 0x57 # W
    ori $16, $0, 0x6F # o
    ori $17, $0, 0x72 # r
    ori $18, $0, 0x6C # l
    ori $19, $0, 0x64 # d
    ori $20, $0, 0x21 # !
    ori $21, $0, 0x0A # \n
 
    sll $0, $0, 0
    sll $0, $0, 0

    sw $8, $2, 0 # print $8 to screen
    sw $9, $2, 0
    sw $10, $2, 0
    sw $21, $2, 0
    j X
    sw $20, $2, 0
    sw $20, $2, 0
    sw $20, $2, 0
    sw $20, $2, 0
    sw $20, $2, 0
    sw $20, $2, 0
X:
    sw $17, $2, 0
    sw $18, $2, 0
    sw $19, $2, 0
    sw $20, $2, 0

    sw $21, $2, 0
    halt

    sw $20, $2, 0 # should not print another '!'
