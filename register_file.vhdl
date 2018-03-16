LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

ENTITY RegFile IS
    PORT (reg1, reg2, writeReg: IN reg_address;
          WE, clock: IN STD_LOGIC;
          writeData: IN word;
          read1Data, read2Data: OUT word);


END RegFile;

ARCHITECTURE behavior OF RegFile IS
    SIGNAL d_out: word;
    SIGNAL regs: word_array;
BEGIN

    dec: ENTITY work.decoder5_32(logic) PORT MAP (writeReg, WE, d_out);

    -- zero register
    r0: ENTITY work.register32(behavior) PORT MAP (writeData, '0', clock, regs(0));

    genReg : FOR i IN 1 to 31 GENERATE
        r: ENTITY work.register32(behavior) PORT MAP (writeData, d_out(i), clock, regs(i));
    END GENERATE genReg;
    
    mux1: ENTITY work.Mux32x32_1(logic) PORT MAP (regs, reg1, read1Data);
    mux2: ENTITY work.Mux32x32_1(logic) PORT MAP (regs, reg2, read2Data);


END behavior;
