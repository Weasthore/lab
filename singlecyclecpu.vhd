library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SingleCycleCPU is
port(clk :in STD_LOGIC;
     rst :in STD_LOGIC;
     --Probe ports used for testing
     --The current address (AddressOut from the PC)
     DEBUG_PC : out STD_LOGIC_VECTOR(63 downto 0);
     --The current instruction (Instruction output of IMEM)
     DEBUG_INSTRUCTION : out STD_LOGIC_VECTOR(31 downto 0);
	     --DEBUG ports from other components
     DEBUG_TMP_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
     DEBUG_SAVED_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
     DEBUG_MEM_CONTENTS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)
);
end SingleCycleCPU;

architecture structural of SingleCycleCPU is


component PC is -- 32-bit rising-edge triggered register with write-enable and synchronous reset
-- For more information on what the PC does, see page 251 in the textbook
port(
     clk          : in  STD_LOGIC; -- Propogate AddressIn to AddressOut on rising edge of clock
     write_enable : in  STD_LOGIC; -- Only write if '1'
     rst          : in  STD_LOGIC; -- Asynchronous reset! Sets AddressOut to 0x0
     AddressIn    : in  STD_LOGIC_VECTOR(63 downto 0); -- Next PC address
     AddressOut   : out STD_LOGIC_VECTOR(63 downto 0) -- Current PC address
);
end component;


component IMEM is
-- The instruction memory is a byte addressable, big-endian, read-only memory
-- Reads occur continuously
generic(NUM_BYTES : integer := 64);
-- NUM_BYTES is the number of bytes in the memory (small to save computation resources)
port(
     Address  : in  STD_LOGIC_VECTOR(63 downto 0); -- Address to read from
     ReadData : out STD_LOGIC_VECTOR(31 downto 0)
);
end component;


component CPUControl is
-- Functionality should match the truth table shown in Figure 4.22 of the textbook, inlcuding the
--    output 'X' values.
-- The truth table in Figure 4.22 omits the jump instruction:
--    UBranch = '1'
--    MemWrite = RegWrite = '0'
--    all other outputs = 'X'
port(Opcode   : in  STD_LOGIC_VECTOR(10 downto 0);
     RegDst   : out STD_LOGIC;
     CBranch   : out STD_LOGIC;
     MemRead  : out STD_LOGIC;
     MemtoReg : out STD_LOGIC;
     MemWrite : out STD_LOGIC;
     ALUSrc   : out STD_LOGIC;
     RegWrite : out STD_LOGIC;
     UBranch     : out STD_LOGIC;
     ALUOp    : out STD_LOGIC_VECTOR(1 downto 0)
);
end component;

component MUX5 is -- Two by one mux with 5 bit inputs/outputs
port(
    in0    : in STD_LOGIC_VECTOR(4 downto 0); -- sel == 0
    in1    : in STD_LOGIC_VECTOR(4 downto 0); -- sel == 1
    sel    : in STD_LOGIC; -- selects in0 or in1
    output : out STD_LOGIC_VECTOR(4 downto 0)
);
end component;

component registers is
generic(NUM_BYTES : integer := 32);
port(RR1      : in  STD_LOGIC_VECTOR (4 downto 0); 
     RR2      : in  STD_LOGIC_VECTOR (4 downto 0); 
     WR       : in  STD_LOGIC_VECTOR (4 downto 0); 
     WD       : in  STD_LOGIC_VECTOR (63 downto 0);
     RegWrite : in  STD_LOGIC;
     Clock    : in  STD_LOGIC;
     RD1      : out STD_LOGIC_VECTOR (63 downto 0);
     RD2      : out STD_LOGIC_VECTOR (63 downto 0);
	 test9      : buffer STD_LOGIC_VECTOR (63 downto 0);--
	 test10      : buffer STD_LOGIC_VECTOR (63 downto 0);--
     test11      : buffer STD_LOGIC_VECTOR (63 downto 0);--
     --Probe ports used for testing
     -- $t0 & $t1 & t2 & t3
     DEBUG_TMP_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
     -- $s0 & $s1 & s2 & s3
     DEBUG_SAVED_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)
);
end component;

component SignExtend is
port(
     a : in  STD_LOGIC_VECTOR(3 downto 0);  --original pc leftmost 4 bits 
     x : in  STD_LOGIC_VECTOR(31 downto 0);
	 z : out STD_LOGIC_VECTOR(63 downto 0); -- sign-extend(x)
     y : out STD_LOGIC_VECTOR(63 downto 0) -- sign-extend(x)
);
end component;

component ShiftLeft2 is -- Shifts the input by 2 bits
port(
     x : in  STD_LOGIC_VECTOR(63 downto 0);
     y : out STD_LOGIC_VECTOR(63 downto 0) -- x << 2
);
end component;

component ADD is
-- Adds two signed 32-bit inputs
-- output = in1 + in2
port(
     in0    : in  STD_LOGIC_VECTOR(63 downto 0);
     in1    : in  STD_LOGIC_VECTOR(63 downto 0);
     output : out STD_LOGIC_VECTOR(63 downto 0)
);
end component;

component MUX64 is -- Two by one mux with 32 bit inputs/outputs
port(
    in0    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 0
    in1    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 1
    sel    : in STD_LOGIC; -- selects in0 or in1
    output : out STD_LOGIC_VECTOR(63 downto 0)
);
end component;

component ALU is
-- Implement: AND, OR, ADD (signed), SUBTRACT (signed)
--    as described in Section 4.4 in the textbook.
-- The functionality of each instruction can be found on the 'MIPS Reference Data' sheet at the
--    front of the textbook.
port(
     a         : in     STD_LOGIC_VECTOR(63 downto 0);
     b         : in     STD_LOGIC_VECTOR(63 downto 0);
     operation : in     STD_LOGIC_VECTOR(3 downto 0);
     result    : buffer STD_LOGIC_VECTOR(63 downto 0);
     zero      : buffer STD_LOGIC;
     overflow  : buffer STD_LOGIC;
     temp1     : buffer STD_LOGIC_VECTOR(63 downto 0);
     temp2     : buffer STD_LOGIC_VECTOR(63 downto 0)
);
end component;

component ALUControl is
-- Functionality should match truth table shown in Figure 4.13 in the textbook.
-- You only need to consider the cases where ALUOp = "00", "01", and "10". ALUOp = "11" is not
--    a valid input and need not be considered; its output can be anything, including "0110",
--    "0010", "XXXX", etc.
-- To ensure proper functionality, you must implement the "don't-care" values in the funct field,
-- for example when ALUOp = '00", Operation must be "0010" regardless of what Funct is.
-- Check Figure 4.4.1 COD 4.12        
port(
     ALUOp     : in  STD_LOGIC_VECTOR(1 downto 0);
     Opecode    : in   STD_LOGIC_VECTOR(10 downto 0);
     Operation : out STD_LOGIC_VECTOR(3 downto 0)
);
end component;

component AND2 is
port (
      in0    : in  STD_LOGIC;
      in1    : in  STD_LOGIC;
      output : out STD_LOGIC -- in0 and in1
);
end component;

component DMEM is
-- The data memory is a byte addressble, big-endian, read/write memory with a single address port
-- It may not read and write at the same time
generic(NUM_BYTES : integer := 64);
-- NUM_BYTES is the number of bytes in the memory (small to save computation resources)
port(
     WriteData          : in  STD_LOGIC_VECTOR(63 downto 0); -- Input data
     Address            : in  STD_LOGIC_VECTOR(63 downto 0); -- Read/Write address
     MemRead            : in  STD_LOGIC; -- Indicates a read operation
     MemWrite           : in  STD_LOGIC; -- Indicates a write operation
     Clock              : in  STD_LOGIC; -- Writes are triggered by a rising edge
     ReadData           : out STD_LOGIC_VECTOR(63 downto 0); -- Output data
     --Probe ports used for testing
     -- Four 64-bit words: DMEM(0) & DMEM(4) & DMEM(8) & DMEM(12)
     DEBUG_MEM_CONTENTS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)
);
end component;

component ORgate is

port(
     in0    : in  STD_LOGIC;
     in1    : in  STD_LOGIC;
     output : out STD_LOGIC
);
end component;

component ShiftLeft2UBranch is
port(
     x : in  STD_LOGIC_VECTOR(31 downto 0);
     y : in  STD_LOGIC_VECTOR(3  downto 0);
     z : out STD_LOGIC_VECTOR(63 downto 0)
);
end component;



signal PCAddressIn,PCAddressOut,RD1,RD2,WD,signextendout,shift2out,newpc,aluin,aluresult,dmemoutput,pcaddr,PCchoice1,PCchoice0:STD_LOGIC_VECTOR(63 downto 0);
signal RegDst,CBranch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite,UBranch,zero,andout,orout:STD_LOGIC;
signal instruction:STD_LOGIC_VECTOR(31 downto 0);
signal ALUOp:STD_LOGIC_VECTOR(1 downto 0);
signal mux5_out:STD_LOGIC_VECTOR(4 downto 0);
signal alucontroloutput:STD_LOGIC_VECTOR(3 downto 0);
constant clk_period :time :=200 ns;    
signal PC4:STD_LOGIC_VECTOR(63 downto 0):="0000000000000000000000000000000000000000000000000000000000000100";
signal PCwrite_enable:STD_LOGIC:='1';


begin

U1: pc port map(clk=>clk,write_enable=>PCwrite_enable,rst=>rst,AddressIn=>pcaddr,AddressOut=>PCAddressOut);
U2: IMEM port map(Address=>PCAddressOut,ReadData=>instruction);
U3: CPUControl port map(Opcode=>instruction(31 downto 21),RegDst=>RegDst,CBranch=>CBranch,MemRead=>MemRead,MemWrite=>MemWrite,ALUSrc=>ALUSrc,RegWrite=>RegWrite,UBranch=>UBranch,ALUOp=>ALUOp,MemtoReg=>MemtoReg);
U4: MUX5 port map(in0=>instruction(20 downto 16),in1=>instruction(4 downto 0),sel=>RegDst,output=>mux5_out);
U5: registers port map(RR1=>instruction(9 downto 5),RR2=>mux5_out,WR=>instruction(4 downto 0),WD=>WD,RegWrite=>RegWrite,Clock=>clk,RD1=>RD1,RD2=>RD2);
U6: SignExtend port map(a=>PCAddressOut(63 downto 60),x=>instruction(31 downto 0),y=>signextendout);
U7: ShiftLeft2 port map(x=>signextendout,y=>shift2out);
U8: ADD port map(in0=>PCAddressOut,in1=>shift2out,output=>newpc);
U9: MUX64 port map(in0=>RD2,in1=>signextendout,sel=>ALUSrc,output=>aluin);
U10: ALU port map(a=>RD1,b=>aluin,operation=>alucontroloutput,result=>aluresult,zero=>zero,overflow=>open);
U11: ALUControl port map(ALUOp=>ALUOp,Opecode=>instruction(31 downto 21),Operation=>alucontroloutput);
U12: AND2 port map(in0=>CBranch,in1=>zero,output=>andout);
U13: DMEM port map(WriteData=>RD2,Address=>aluresult,MemRead=>MemRead,MemWrite=>MemWrite,Clock=>clk,ReadData=>dmemoutput);
U14: ADD port map(in0=>PCAddressOut,in1=>PC4,output=>PCAddressIn);
U16: MUX64 port map(in0=>aluresult,in1=>dmemoutput,sel=>MemtoReg,output=>WD);
U17: MUX64 port map(in0=>PCAddressIn,in1=>newpc,sel=>orout,output=>pcaddr);
U18: ORgate port map(in0=>andout,in1=>UBranch,output=>orout);


end;