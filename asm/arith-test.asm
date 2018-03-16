# Perform multiple instructions on the first two inputs from std-in, assuming they are numbers
    ori $2, $0, 0xFFFC # store output address to $2
    ori $3, $0, 0xFFF8 # store input address to $3

    ori $8, $0, 0x30 # ASCII value of '0'

    lw $16, $3, 0
    lw $17, $3, 0

    sub $16, $16, $8 # Correct for ASCII input
    sub $17, $17, $8

    ori $4, $0, 0x0A #\n
    sw  $4, $2, 0
    ori $4, $0, 0x73 #s
    sw  $4, $2, 0
    ori $4, $0, 0x75 #u
    sw  $4, $2, 0
    ori $4, $0, 0x62 #b
    sw  $4, $2, 0
    ori $4, $0, 0x3A #:
    sw  $4, $2, 0
    ori $4, $0, 0x20 #(space)
    sw  $4, $2, 0

    sub $9, $16, $17
    addi $9, $9, 0x30 # Convert for ASCII output
    sw $9, $2, 0

    ori $4, $0, 0x0A #\n
    sw  $4, $2, 0
    ori $4, $0, 0x61 #a
    sw  $4, $2, 0
    ori $4, $0, 0x64 #d
    sw  $4, $2, 0
    ori $4, $0, 0x64 #d
    sw  $4, $2, 0
    ori $4, $0, 0x3A #:
    sw  $4, $2, 0
    ori $4, $0, 0x20 #(space)
    sw  $4, $2, 0

    add $9, $16, $17
    addi $9, $9, 0x30 # Convert for ASCII output
    sw $9, $2, 0

    ori $4, $0, 0x0A #\n
    sw  $4, $2, 0
    ori $4, $0, 0x61 #a
    sw  $4, $2, 0
    ori $4, $0, 0x64 #d
    sw  $4, $2, 0
    ori $4, $0, 0x64 #d
    sw  $4, $2, 0
    ori $4, $0, 0x75 #u
    sw  $4, $2, 0
    ori $4, $0, 0x3A #:
    sw  $4, $2, 0
    ori $4, $0, 0x20 #(space)
    sw  $4, $2, 0

    addu $9, $16, $17
    addi $9, $9, 0x30 # Convert for ASCII output
    sw $9, $2, 0

    ori $4, $0, 0x0A #\n
    sw  $4, $2, 0
    ori $4, $0, 0x6E #n
    sw  $4, $2, 0
    ori $4, $0, 0x6F #o
    sw  $4, $2, 0
    ori $4, $0, 0x72 #r
    sw  $4, $2, 0
    ori $4, $0, 0x3A #:
    sw  $4, $2, 0
    ori $4, $0, 0x20 #(space)
    sw  $4, $2, 0

    nor $9, $16, $17
    addi $9, $9, 0x30 # Convert for ASCII output
    sw $9, $2, 0

    ori $4, $0, 0x0A #\n
    sw  $4, $2, 0
    ori $4, $0, 0x73 #s
    sw  $4, $2, 0
    ori $4, $0, 0x6C #l
    sw  $4, $2, 0
    ori $4, $0, 0x6C #l
    sw  $4, $2, 0
    ori $4, $0, 0x3A #:
    sw  $4, $2, 0
    ori $4, $0, 0x20 #(space)
    sw  $4, $2, 0

    add $9, $16, $0
    sll $9, $9, 2
    addi $9, $9, 0x30 # Convert for ASCII output
    sw $9, $2, 0

    ori $4, $0, 0x0A #\n
    sw  $4, $2, 0
    ori $4, $0, 0x73 #s
    sw  $4, $2, 0
    ori $4, $0, 0x72 #r
    sw  $4, $2, 0
    ori $4, $0, 0x6C #l
    sw  $4, $2, 0
    ori $4, $0, 0x3A #:
    sw  $4, $2, 0
    ori $4, $0, 0x20 #(space)
    sw  $4, $2, 0

    add $9, $16, $0
    srl $9, $9, 2
    addi $9, $9, 0x30 # Convert for ASCII output
    sw $9, $2, 0

    ori $4, $0, 0x0A #\n
    sw  $4, $2, 0
    ori $4, $0, 0x78 #x
    sw  $4, $2, 0
    ori $4, $0, 0x6F #o
    sw  $4, $2, 0
    ori $4, $0, 0x72 #r
    sw  $4, $2, 0
    ori $4, $0, 0x3A #:
    sw  $4, $2, 0
    ori $4, $0, 0x20 #(space)
    sw  $4, $2, 0

    xor $9, $16, $17
    addi $9, $9, 0x30 # Convert for ASCII output
    sw $9, $2, 0

    ori $4, $0, 0x0A #\n
    sw  $4, $2, 0
    halt
