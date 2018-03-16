# Perform multiple instructions on the first two inputs from std-in, assuming they are numbers
    ori $2, $0, 0xFFFC # store output address to $2
    ori $3, $0, 0xFFF8 # store input address to $3

    ori $8, $0, 0x30 # ASCII value of '0'

    sll $0, $0, 0
    sll $0, $0, 0
    sll $0, $0, 0

    lw $16, $3, 0
    lw $17, $3, 0
    sll $0, $0, 0
    sll $0, $0, 0
    sll $0, $0, 0
    sub $16, $16, $8 # Correct for ASCII input
    sll $0, $0, 0
    sll $0, $0, 0
    sll $0, $0, 0
    sub $17, $17, $8
    sll $0, $0, 0
    sll $0, $0, 0
    sll $0, $0, 0
    sll $0, $0, 0
    sub $9, $16, $17
    ori $24, $0, 0x0A #\n
    ori $25, $0, 0x73 #s
    ori $26, $0, 0x75 #u
    ori $27, $0, 0x62 #b
    ori $28, $0, 0x3A #:
    ori $29, $0, 0x20 #(space)
    addi $9, $9, 0x30 # Convert for ASCII output
    sw  $24, $2, 0
    sw  $25, $2, 0
    sw  $26, $2, 0
    sw  $27, $2, 0
    sw  $28, $2, 0
    sw  $29, $2, 0
    sll $0, $0, 0
    sll $0, $0, 0
    sll $0, $0, 0
    sw $9, $2, 0
    add $9, $16, $17
    ori $24, $0, 0x0A #\n
    ori $25, $0, 0x61 #a
    ori $26, $0, 0x64 #d
    ori $27, $0, 0x64 #d
    ori $28, $0, 0x3A #:
    ori $29, $0, 0x20 #(space)
    addi $9, $9, 0x30 # Convert for ASCII output
    sw  $24, $2, 0
    sw  $25, $2, 0
    sw  $26, $2, 0
    sw  $27, $2, 0
    sw  $28, $2, 0
    sw  $29, $2, 0

    sw $9, $2, 0
    addu $9, $16, $17
    ori $30, $0, 0x0A #\n
    ori $24, $0, 0x61 #a
    ori $25, $0, 0x64 #d
    ori $26, $0, 0x64 #d
    ori $27, $0, 0x75 #u
    ori $28, $0, 0x3A #:
    ori $29, $0, 0x20 #(space)
    addi $9, $9, 0x30 # Convert for ASCII output
    sw  $30, $2, 0
    sw  $24, $2, 0
    sw  $25, $2, 0
    sw  $26, $2, 0
    sw  $27, $2, 0
    sw  $28, $2, 0
    sw  $29, $2, 0
    sw $9, $2, 0

    nor $9, $16, $17
    ori $24, $0, 0x0A #\n
    ori $25, $0, 0x6E #n
    ori $26, $0, 0x6F #o
    ori $27, $0, 0x72 #r
    ori $28, $0, 0x3A #:
    ori $29, $0, 0x20 #(space)
    addi $9, $9, 0x30 # Convert for ASCII output
    sw  $24, $2, 0
    sw  $25, $2, 0
    sw  $26, $2, 0
    sw  $27, $2, 0
    sw  $28, $2, 0
    sw  $29, $2, 0
    sw $9, $2, 0

    add $9, $16, $0
    sll $0, $0, 0
    sll $0, $0, 0
    sll $0, $0, 0
    sll $9, $9, 2
    ori $24, $0, 0x0A #\n
    ori $25, $0, 0x73 #s
    ori $26, $0, 0x6C #l
    ori $27, $0, 0x6C #l
    ori $28, $0, 0x3A #:
    ori $29, $0, 0x20 #(space)
    addi $9, $9, 0x30 # Convert for ASCII output
    sw  $24, $2, 0
    sw  $25, $2, 0
    sw  $26, $2, 0
    sw  $27, $2, 0
    sw  $28, $2, 0
    sw  $29, $2, 0
    sw $9, $2, 0
    sll $0, $0, 0
    sll $0, $0, 0
    sll $0, $0, 0
    sll $0, $0, 0

    add $9, $16, $0
    sll $0, $0, 0
    sll $0, $0, 0
    sll $0, $0, 0
    srl $9, $9, 2
    ori $24, $0, 0x0A #\n
    ori $25, $0, 0x73 #s
    ori $26, $0, 0x72 #r
    ori $27, $0, 0x6C #l
    ori $28, $0, 0x3A #:
    ori $29, $0, 0x20 #(space)
    addi $9, $9, 0x30 # Convert for ASCII output
    sw  $24, $2, 0
    sw  $25, $2, 0
    sw  $26, $2, 0
    sw  $27, $2, 0
    sw  $28, $2, 0
    sw  $29, $2, 0
    sw $9, $2, 0

    xor $9, $16, $17
    ori $24, $0, 0x0A #\n
    ori $25, $0, 0x78 #x
    ori $26, $0, 0x6F #o
    ori $27, $0, 0x72 #r
    ori $28, $0, 0x3A #:
    ori $29, $0, 0x20 #(space)
    addi $9, $9, 0x30 # Convert for ASCII output
    sw  $24, $2, 0
    sw  $25, $2, 0
    sw  $26, $2, 0
    sw  $27, $2, 0
    sw  $28, $2, 0
    sw  $29, $2, 0
    sw $9, $2, 0

    sw  $24, $2, 0
    halt
