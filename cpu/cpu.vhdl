LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

ENTITY CPU IS
END CPU;

ARCHITECTURE logic OF CPU IS
    SIGNAL CE: STD_LOGIC := '1';
    SIGNAL h1: STD_LOGIC := '0';
    SIGNAL h2: STD_LOGIC := '0';
    SIGNAL c: STD_LOGIC := '1';

    SIGNAL PC_we: STD_LOGIC := '1';
    SIGNAL PC_in: word;
    SIGNAL PC_out: word;
    SIGNAL PC_sum: word;
    SIGNAL PC_ext_sh_Branch: word;

    SIGNAL imm_data: word;

    SIGNAL PC_branch: STD_LOGIC;
    SIGNAL PC_branch_4_pair: word_pair;
    SIGNAL PC_options: word_array4;

    SIGNAL ncs_i: STD_LOGIC := '0';
    SIGNAL nwe_i: STD_LOGIC := '1';
    SIGNAL noe_i: STD_LOGIC := '1';
    --SIGNAL addr_i: word;
    SIGNAL data_i: word := "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
    SIGNAL notC_instFetch: STD_LOGIC := '1'; --start high to trigger a falling edge for noe_i right away

    SIGNAL ncs_d: STD_LOGIC := '0';
    SIGNAL nwe_d: STD_LOGIC := '1';
    SIGNAL noe_d: STD_LOGIC := '1';
    SIGNAL addr_d: word := x"00000000";
    SIGNAL data_d: word := "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
    SIGNAL c_dataOp: STD_LOGIC;
    SIGNAL data_pulse: STD_LOGIC := '1';

    SIGNAL reg1, reg2, writeReg: reg_address;
    SIGNAL writeRegOptions: reg_addr_array4;
    SIGNAL writeRegData, reg1Data, reg2Data: word;

    SIGNAL writeDataOptions: word_array4;

    SIGNAL alu_src1_options: word_pair;
    SIGNAL alu_src2_options: word_array4;
    SIGNAL alu_in1, alu_in2: word;
    SIGNAL alu_op: op_type;
    SIGNAL alu_out: word := x"00000000";
    SIGNAL zfl, cfl, ofl, nfl: STD_LOGIC;

    SIGNAL Operation: STD_LOGIC_VECTOR(31 DOWNTO 26) := "000000";
    SIGNAL Func: STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL Branch, MemRead, MemWrite, regfile_WE, SignExtend, ALUSrc1: STD_LOGIC;
    SIGNAL ALUSrc2, MemToReg, WriteRegDst, ALUOpType: STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL PCSrc: STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";

    --SIGNAL testword: word;

BEGIN

    clock: ENTITY work.clock(logic) PORT MAP (CE, c);

    PC_reg: ENTITY work.register32(behavior) PORT MAP (PC_in, PC_we, c, PC_out);
    PC_adder: ENTITY work.f_adder32(logic) PORT MAP (PC_out, x"00000004", '0', '0', PC_sum, open, open, open, open);

    PC_branch <= Branch AND zfl AFTER 5 ps;
    imm_extend: ENTITY work.sign_extender(logic) PORT MAP (data_i(15 downto 0), SignExtend, imm_data);
    PC_branch_4_pair(0) <= PC_sum;
    PC_ext_sh_Branch <= imm_data(29 downto 0) & "00";
    PC_branch_adder: ENTITY work.f_adder32(logic) PORT MAP (PC_sum, PC_ext_sh_Branch, '0', '0', PC_branch_4_pair(1), open, open, open, open);

    pc4_or_branch_mux: ENTITY work.Mux2x32_1(logic) PORT MAP (PC_branch_4_pair, PC_branch, PC_options(0));

    PC_options(1) <= PC_sum(31 downto 28) & data_i(25 downto 0) & "00";
    PC_options(2) <= reg1Data;

    PC_in_mux4: ENTITY work.Mux4x32_1(logic) PORT MAP (PC_options, PCSrc, PC_in);



    notC_instFetch <= NOT c AFTER 25 ps;

    inst_pulser: ENTITY work.pulser(logic) PORT MAP (notC_instFetch, noe_i);
    sram_inst: ENTITY work.sram64kx8 PORT MAP(ncs_i, PC_out, data_i, nwe_i, noe_i);


    Operation <= data_i(31 downto 26);
    Func <= data_i(5 downto 0);


    
    -- check for halt
    h1 <= Operation(31) AND Operation(30) AND Operation(29) AFTER 100 ps;
    h2 <= Operation(28) AND Operation(27) AND Operation(26) AFTER 100 ps;
    CE <= h1 NAND h2 AFTER 5 ps;
    ncs_d <= h1 AND h2 AFTER 5 ps;
    ncs_i <= h1 AND h2 AFTER 5 ps;

    control: ENTITY work.Control(Behavior) PORT MAP (Operation, Func, Branch, MemRead, MemWrite, regfile_WE, SignExtend,
                                                     ALUSrc1, ALUSrc2, MemToReg, WriteRegDst, PCSrc, ALUOpType);
    alu_control: ENTITY work.ALUControl(Behavior) PORT MAP (ALUOpType, Func, alu_op);



    reg1 <= data_i(25 downto 21);
    reg2 <= data_i(20 downto 16);

    writeRegOptions(0) <= reg2;
    writeRegOptions(1) <= data_i(15 downto 11);
    writeRegOptions(2) <= "11111"; -- 31

    rd_mux: ENTITY work.Mux4x5_1(logic) PORT MAP (writeRegOptions, WriteRegDst, writeReg);
    reg_file: ENTITY work.RegFile(behavior) PORT MAP (reg1, reg2, writeReg, regfile_WE, c, writeRegData, reg1Data, reg2Data);



    alu_src1_options(0) <= reg1Data;
    alu_src1_options(1) <= x"00000004";

    alu_src1_mux: ENTITY work.Mux2x32_1(logic) PORT MAP (alu_src1_options, ALUSrc1, alu_in1);

    alu_src2_options(0) <= reg2Data;
    alu_src2_options(1) <= imm_data;
    alu_src2_options(2) <= "000000000000000000000000000" & data_i(10 downto 6); -- 32-bit extended 5 bits from the shift amt
    alu_src2_options(3) <= PC_sum;

    alu_src2_mux: ENTITY work.Mux4x32_1(logic) PORT MAP (alu_src2_options, ALUSrc2, alu_in2);

    alu: ENTITY work.alu(logic) PORT MAP (alu_in1, alu_in2, alu_op, alu_out, ofl, nfl, zfl, cfl);

    
    c_dataOp <= c;
    data_pulser: ENTITY work.pulser(logic) PORT MAP (c_dataOp, data_pulse);
    noe_d <= (data_pulse AND MemRead) OR MemWrite AFTER 10 ps;
    nwe_d <= data_pulse NAND MemWrite AFTER 5 ps;

    addr_d <= alu_out;
    sram_data: ENTITY work.sram64kx8 PORT MAP(ncs_d, addr_d, data_d, nwe_d, noe_d);

    writeDataOptions(0) <= alu_out;
    writeDataOptions(1) <= data_d;
    writeDataOptions(2) <= PC_sum;

    mem_to_reg_mux: ENTITY work.Mux4x32_1(logic) PORT MAP (writeDataOptions, MemToReg, writeRegData);
    

    PROCESS
        BEGIN
        WAIT UNTIL c'event and c = '0';
        if MemWrite = '1' then
            data_d <= reg2Data;
        elsif MemRead = '1' then
            data_d <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
        end if;
    END PROCESS;
END logic;
