LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.p.all;

ENTITY CPU IS
END CPU;

ARCHITECTURE pipelined OF CPU IS
    SIGNAL CE: STD_LOGIC := '1';
    SIGNAL h1: STD_LOGIC := '0';
    SIGNAL h2: STD_LOGIC := '0';
    SIGNAL c: STD_LOGIC := '1';

    SIGNAL PC_we: STD_LOGIC := '1';
    SIGNAL PC_in: word;
    SIGNAL PC_out: word;
    SIGNAL PC_sum: word;
    SIGNAL PC_ext_sh_Branch: word;
    SIGNAL PC_plus_branch: word;

    SIGNAL imm_data: word;

    SIGNAL PC_4_or_branch: STD_LOGIC;
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
    SIGNAL data_write_pulse: STD_LOGIC := '1';

    SIGNAL reg1, reg2, writeReg: reg_address;
    SIGNAL writeRegOptions: reg_addr_array4;
    SIGNAL writeRegData, reg1Data, reg2Data: word;
    SIGNAL regfile_WE: STD_LOGIC := '1';

    SIGNAL writeDataOptions: word_array4;

    SIGNAL alu_src1_options: word_pair;
    SIGNAL alu_src2_options: word_array4;
    SIGNAL alu_in1, alu_in2: word;
    SIGNAL alu_op: op_type;
    SIGNAL alu_out: word := x"00000000";
    SIGNAL zfl, cfl, ofl, nfl, eql: STD_LOGIC;

    SIGNAL Operation: STD_LOGIC_VECTOR(31 DOWNTO 26) := "000000";
    SIGNAL Func: STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL Branch, MemRead, MemWrite, RegWrite, SignExtend, ALUSrc1, Halt: STD_LOGIC;
    SIGNAL ALUSrc2, MemToReg, WriteRegDst, ALUOpType: STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL PCSrc: STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";

    SIGNAL IF_ID_WE: STD_LOGIC := '1';
    SIGNAL IF_ID_Out: STD_LOGIC_VECTOR(63 downto 0);
    SIGNAL IF_ID_In: STD_LOGIC_VECTOR(63 downto 0);

    SIGNAL ID_EX_WE: STD_LOGIC := '1';
    SIGNAL ID_EX_Out: STD_LOGIC_VECTOR(145 downto 0);
    SIGNAL ID_EX_In: STD_LOGIC_VECTOR(145 downto 0);

    SIGNAL EX_MEM_WE: STD_LOGIC := '1';
    SIGNAL EX_MEM_Out: STD_LOGIC_VECTOR(106 downto 0);
    SIGNAL EX_MEM_In: STD_LOGIC_VECTOR(106 downto 0);

    SIGNAL MEM_WB_WE: STD_LOGIC := '1';
    SIGNAL MEM_WB_Out: STD_LOGIC_VECTOR(104 downto 0);
    SIGNAL MEM_WB_In: STD_LOGIC_VECTOR(104 downto 0);

BEGIN

    clock: ENTITY work.clock(pipelined) PORT MAP (CE, c);

--- BEGIN IF ---
    PC_reg: ENTITY work.register32(behavior) PORT MAP (PC_in, PC_we, c, PC_out);
    PC_adder: ENTITY work.f_adder32(logic) PORT MAP (PC_out, x"00000004", '0', '0', PC_sum, open, open, open, open);
    
    PC_branch_4_pair(0) <= PC_sum;
    pc4_or_branch_mux: ENTITY work.Mux2x32_1(logic) PORT MAP (PC_branch_4_pair, PC_4_or_branch, PC_options(0));

    notC_instFetch <= NOT c AFTER 25 ps;

    inst_pulser: ENTITY work.pulser(logic) PORT MAP (notC_instFetch, noe_i);
    sram_inst: ENTITY work.sram64kx8 PORT MAP(ncs_i, PC_out, data_i, nwe_i, noe_i);

--- IF/ID --- 64
    IF_ID_In(63 downto 32) <= PC_sum;
    IF_ID_In(31 downto 0) <= data_i;
    IF_ID_reg: ENTITY work.gen_reg(behavior) GENERIC MAP(64) PORT MAP (IF_ID_In, IF_ID_WE, c, IF_ID_Out);
--- BEGIN ID ---

    Operation <= IF_ID_Out(31 downto 26);
    Func <= IF_ID_Out(5 downto 0);

    
    -- check for halt --
    h1 <= Operation(31) AND Operation(30) AND Operation(29) AFTER 5 ps;
    h2 <= Operation(28) AND Operation(27) AND Operation(26) AFTER 5 ps;
    Halt <= h1 AND h2 AFTER 5 ps;
    --

    reg1 <= IF_ID_Out(25 downto 21);
    reg2 <= IF_ID_Out(20 downto 16);

    reg_file: ENTITY work.RegFile(behavior) PORT MAP (reg1, reg2, MEM_WB_Out(68 downto 64), regfile_WE, c, writeRegData, reg1Data, reg2Data);
    --writeReg from MEM/WB register
    --writeRegData WB mux

    imm_extend: ENTITY work.sign_extender(logic) PORT MAP (IF_ID_Out(15 downto 0), SignExtend, imm_data);

    control: ENTITY work.Control(Pipelined) PORT MAP (Operation, Func, Branch, MemRead, MemWrite, RegWrite, SignExtend,
                                                     ALUSrc1, ALUSrc2, MemToReg, WriteRegDst, PCSrc, ALUOpType);

    -- PC Calculation --
    comp: ENTITY work.comparator(logic) PORT MAP(reg1Data, reg2Data, eql);
    PC_4_or_branch <= Branch AND eql AFTER 5 ps;
    PC_ext_sh_Branch <= imm_data(29 downto 0) & "00";
    PC_branch_adder: ENTITY work.f_adder32(logic) PORT MAP (IF_ID_Out(63 downto 32), PC_ext_sh_Branch, '0', '0', PC_plus_branch, open, open, open, open); 
    --PC_sum + PC_ext_sh_Branch => PC_plus_branch

    PC_branch_4_pair(1) <= PC_plus_branch;

    --PC_options(0) from pc4_or_branch_mux
    PC_options(1) <= IF_ID_Out(63 downto 60) & IF_ID_Out(25 downto 0) & "00"; --PC_sum(31 downto 28) & data_i(25 downto 0) & "00"
    PC_options(2) <= reg1Data;

    PC_in_mux4: ENTITY work.Mux4x32_1(logic) PORT MAP (PC_options, PCSrc, PC_in);
    --------------------


--- ID/EX --- 128
    ID_EX_In(145) <= Halt;

    ID_EX_In(144 downto 140) <= reg2;

    ID_EX_In(139) <= MemRead;
    ID_EX_In(138) <= MemWrite;
    ID_EX_In(137) <= RegWrite;

    ID_EX_In(136) <= ALUSrc1;

    ID_EX_In(135 downto 134) <= ALUSrc2;

    ID_EX_In(133 downto 132) <= MemToReg;
    ID_EX_In(131 downto 130) <= WriteRegDst;

    ID_EX_In(129 downto 128) <= ALUOpType;

    ID_EX_In(127 downto 96) <= imm_data;
    ID_EX_In(95 downto 64) <= IF_ID_Out(63 downto 32); --PC_sum
    ID_EX_In(63 downto 32) <= reg1Data;
    ID_EX_In(31 downto 0) <= reg2Data;

    ID_EX_reg: ENTITY work.gen_reg(behavior) GENERIC MAP(146) PORT MAP (ID_EX_In, ID_EX_WE, c, ID_EX_Out);

--- BEGIN EX ---
    
    alu_control: ENTITY work.ALUControl(Behavior) PORT MAP (ID_EX_Out(129 downto 128), ID_EX_Out(101 downto 96), alu_op);
	-- ALUOpType
    -- Func from bottom of imm_data

    alu_src1_options(0) <= ID_EX_Out(63 downto 32);
    alu_src1_options(1) <= x"00000004";


    alu_src1_mux: ENTITY work.Mux2x32_1(logic) PORT MAP (alu_src1_options, ID_EX_Out(136), alu_in1); --ALUSrc1

    alu_src2_options(0) <= ID_EX_Out(31 downto 0); -- reg2Data
    alu_src2_options(1) <= ID_EX_Out(127 downto 96); -- imm_data
    alu_src2_options(2) <= "000000000000000000000000000" & ID_EX_Out(106 downto 102); -- 32-bit extended 5 bits from the shift amt (from imm-data)
    alu_src2_options(3) <= ID_EX_Out(95 downto 64); -- PC_sum

    alu_src2_mux: ENTITY work.Mux4x32_1(logic) PORT MAP (alu_src2_options, ID_EX_Out(135 downto 134), alu_in2); --ALUSrc2


    alu: ENTITY work.alu(logic) PORT MAP (alu_in1, alu_in2, alu_op, alu_out, open, open, open, open);--ofl, nfl, zfl, cfl);


    writeRegOptions(0) <= ID_EX_Out(144 downto 140); --reg2 (20-16)
    writeRegOptions(1) <= ID_EX_Out(111 downto 107); --inst (15-11)
    writeRegOptions(2) <= "11111"; -- 31
    rd_mux: ENTITY work.Mux4x5_1(logic) PORT MAP (writeRegOptions, ID_EX_Out(131 downto 130), writeReg); --WriteRegDst

--- EX/MEM --- 97

    EX_MEM_In(106) <= ID_EX_Out(145); --Halt
    EX_MEM_In(105 downto 74) <= ID_EX_Out(95 downto 64); --PC_sum

    EX_MEM_In(73) <= ID_EX_Out(139); --MemRead
    EX_MEM_In(72) <= ID_EX_Out(138); --MemWrite
    EX_MEM_In(71) <= ID_EX_Out(137); --RegWrite

    EX_MEM_In(70 downto 69) <= ID_EX_Out(133 downto 132); --MemToReg
    EX_MEM_In(68 downto 64) <= writeReg;
    EX_MEM_In(63 downto 32) <= alu_out;
    EX_MEM_In(31 downto 0) <= ID_EX_Out(31 downto 0); --reg2Data

    EX_MEM_reg: ENTITY work.gen_reg(behavior) GENERIC MAP(107) PORT MAP (EX_MEM_In, EX_MEM_WE, c, EX_MEM_Out);

--- BEGIN MEM ---
    PROCESS
        BEGIN
        WAIT UNTIL c'event and c = '0';
        if EX_MEM_Out(72) = '1' then
            data_d <= EX_MEM_Out(31 downto 0);
        elsif EX_MEM_Out(73) = '1' then
            data_d <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
        end if;
    END PROCESS;
    c_dataOp <= c;
    data_write_pulser: ENTITY work.pulser(logic) PORT MAP (c_dataOp, data_write_pulse);
    noe_d <= c_dataOp OR (NOT EX_MEM_Out(73)) AFTER 10 ps; -- down on MemRead
    nwe_d <= data_write_pulse NAND EX_MEM_Out(72) AFTER 5 ps; --down on MemWrite

    addr_d <= EX_MEM_Out(63 downto 32); --alu_out
    sram_data: ENTITY work.sram64kx8 PORT MAP(ncs_d, addr_d, data_d, nwe_d, noe_d);

--- MEM/WB --- 64

    MEM_WB_In(104) <= EX_MEM_Out(106); --Halt
    MEM_WB_In(103 downto 72) <= EX_MEM_Out(105 downto 74); --PC_sum

    MEM_WB_In(71) <= EX_MEM_Out(71); --RegWrite
    MEM_WB_In(70 downto 69) <= EX_MEM_Out(70 downto 69); -- MemToReg 
    MEM_WB_In(68 downto 64) <= EX_MEM_Out(68 downto 64); -- writeReg
    MEM_WB_In(63 downto 32) <= EX_MEM_Out(63 downto 32); -- alu_out
    MEM_WB_In(31 downto 0) <= data_d;

    MEM_WB_reg: ENTITY work.gen_reg(behavior) GENERIC MAP(105) PORT MAP (MEM_WB_In, MEM_WB_WE, c, MEM_WB_Out);

--- BEGIN WB ---
    -- check for halt
    CE <= NOT MEM_WB_Out(104) AFTER 5 ps;
    ncs_d <= MEM_WB_Out(104);
    ncs_i <= MEM_WB_Out(104);
    --

    writeDataOptions(0) <= MEM_WB_Out(63 downto 32); -- alu_out
    writeDataOptions(1) <= MEM_WB_Out(31 downto 0); -- data_d
    writeDataOptions(2) <= MEM_WB_Out(103 downto 72); --PC_sum

    mem_to_reg_mux: ENTITY work.Mux4x32_1(logic) PORT MAP (writeDataOptions, MEM_WB_Out(70 downto 69), writeRegData);
    -- MemToReg	
    regfile_WE <= MEM_WB_Out(71); --RegWrite
END pipelined;
