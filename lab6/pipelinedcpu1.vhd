library ieee;  
use ieee.std_logic_1164.all; 
use IEEE.std_logic_signed.all;
use ieee.numeric_std.all; 
entity PipelinedCPU1 is
port(
clk :in std_logic;
rst :in std_logic;
--Probe ports used for testing
     DEBUG_IF_FLUSH : out std_logic;
     DEBUG_REG_EQUAL : out std_logic;
-- Forwarding control signals
DEBUG_FORWARDA : out std_logic_vector(1 downto 0);
DEBUG_FORWARDB : out std_logic_vector(1 downto 0);
--The current address (AddressOut from the PC)
DEBUG_PC : out std_logic_vector(63 downto 0);
--Value of PC.write_enable
DEBUG_PC_WRITE_ENABLE : out STD_LOGIC;
--The current instruction (Instruction output of IMEM)
DEBUG_INSTRUCTION : out std_logic_vector(31 downto 0);
--DEBUG ports from other components
DEBUG_TMP_REGS : out std_logic_vector(64*4-1 downto 0);
DEBUG_SAVED_REGS : out std_logic_vector(64*4-1 downto 0);
DEBUG_MEM_CONTENTS : out std_logic_vector(64*4-1 downto 0)
);
end PipelinedCPU1;



architecture structural of PipelinedCPU1 is


component PC is -- 32-bit rising-edge triggered register with write-enable and synchronous reset
-- For more information on what the PC does, see page 251 in the textbook
port(
     clk          : in  STD_LOGIC; -- Propogate AddressIn to AddressOut on rising edge of clock
     PCWrite : in  STD_LOGIC; -- Only write if '1'
     rst          : in  STD_LOGIC; -- Asynchronous reset! Sets AddressOut to 0x0
     AddressIn    : in  STD_LOGIC_VECTOR(63 downto 0); -- Next PC address
     AddressOut   : out STD_LOGIC_VECTOR(63 downto 0) -- Current PC address
);
end component;

component ALUControl is    
port(
     ALUOp     : in  STD_LOGIC_VECTOR(1 downto 0);
     Opcode    : in   STD_LOGIC_VECTOR(10 downto 0);
     Operation : out STD_LOGIC_VECTOR(3 downto 0)
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

component IfId is 
port(
          IfId_instruction_in        : in std_logic_vector(31 downto 0);
          IfId_pc_in           : in std_logic_vector(63 downto 0);
	  IfIdWrite            : in std_logic; 
          clk                  : in std_logic;
	  ifflush		: in std_logic;
          IfId_instruction_out   : out std_logic_vector(31 downto 0);
          IfId_pc_out      : out std_logic_vector(63 downto 0));

end component;


component CPUControl is
-- Functionality should match the truth table shown in Figure 4.22 of the textbook, inlcuding the
--    output 'X' values.
-- The truth table in Figure 4.22 omits the jump instruction:
--    UBranch = '1'
--    MemWrite = RegWrite = '0'
--    all other outputs = 'X'
port(Opcode   : in  STD_LOGIC_VECTOR(10 downto 0);
     Control  : in STD_LOGIC;
	CBZresult : in STD_LOGIC;
     --Reg2Loc  : out STD_LOGIC;
     CBranch  : out STD_LOGIC;  --conditional
     MemRead  : out STD_LOGIC;
     MemtoReg : out STD_LOGIC;
     MemWrite : out STD_LOGIC;
     ALUSrc   : out STD_LOGIC;
     RegWrite : out STD_LOGIC;
     UBranch  : out STD_LOGIC; -- This is unconditional
     ALUOp    : out STD_LOGIC_VECTOR(1 downto 0);
	ifflush :out STD_LOGIC
);
end component;


component registers is
port(RR1 : in STD_LOGIC_VECTOR (4 downto 0);
RR2 : in STD_LOGIC_VECTOR (4 downto 0);
WR : in STD_LOGIC_VECTOR (4 downto 0);
WD : in STD_LOGIC_VECTOR (63 downto 0);
RegWrite : in STD_LOGIC;
Clock : in STD_LOGIC;
RD1 : out STD_LOGIC_VECTOR (63 downto 0);
RD2 : out STD_LOGIC_VECTOR (63 downto 0);
--Probe ports used for testing.
-- Notice the width of the port means that you are
-- reading only part of the register file.
-- This is only for debugging
-- You are debugging a sebset of registers here
-- Temp registers: $X9 & $X10 & X11 & X12
-- 4 refers to number of registers you are debugging
DEBUG_TMP_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
  
-- Saved Registers X19 & $X20 & X21 & X22
DEBUG_SAVED_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)
);
end component;

component IdEx is 
port(
	  clk              : in std_logic;
          IdEx_Reg2Loc_in   : in STD_LOGIC;
          IdEx_MemRead_in  : in STD_LOGIC;	
	  IdEx_MemWrite_in : in STD_LOGIC;
          IdEx_MemtoReg_in : in STD_LOGIC;
	  IdEx_RegWrite_in : in STD_LOGIC;
          IdEx_ALUSrc_in   : in STD_LOGIC;
	  IdEx_ALUOp_in    : in STD_LOGIC_VECTOR(1 downto 0);
	  IdEx_CBranch_in  : in STD_LOGIC;
          IdEx_UBranch_in  : in STD_LOGIC;      
          IdEx_pc_in       : in std_logic_vector(63 downto 0);  
	  IdEx_RD1_in       : in STD_LOGIC_VECTOR (63 downto 0); 
          IdEx_RD2_in       : in STD_LOGIC_VECTOR (63 downto 0);  
          IdEx_signextend_in       : in std_logic_vector(63 downto 0);  
          IdEx_instruction11_in       : in std_logic_vector(10 downto 0);  
          IdEx_instruction5_in       : in std_logic_vector(4 downto 0);      
          IdEx_Rn_in       : in std_logic_vector(4 downto 0);    
          IdEx_Rm_in       : in std_logic_vector(4 downto 0);    
          IdEx_Rd_in       : in std_logic_vector(4 downto 0);    
	  IdEx_sturinstruct_in       : in std_logic_vector(10 downto 0);    
              
    
          IdEx_Reg2Loc      : out STD_LOGIC;
          IdEx_CBranch     : out STD_LOGIC;
          IdEx_MemRead     : out STD_LOGIC;
          IdEx_MemtoReg    : out STD_LOGIC;
          IdEx_MemWrite    : out STD_LOGIC;
          IdEx_ALUSrc      : out STD_LOGIC;
          IdEx_RegWrite    : out STD_LOGIC;
          IdEx_UBranch     : out STD_LOGIC;
          IdEx_ALUOp       : out STD_LOGIC_VECTOR(1 downto 0);
          IdEx_RD1          : out STD_LOGIC_VECTOR (63 downto 0); 
          IdEx_RD2          : out STD_LOGIC_VECTOR (63 downto 0);
          IdEx_pc       : out std_logic_vector(63 downto 0);  
          IdEx_signextend       : out std_logic_vector(63 downto 0);  
          IdEx_instruction11       : out std_logic_vector(10 downto 0);  
          IdEx_instruction5       : out std_logic_vector(4 downto 0);
	  IdEx_Rn_out       : out std_logic_vector(4 downto 0);    
          IdEx_Rm_out       : out std_logic_vector(4 downto 0);    
          IdEx_Rd_out       : out std_logic_vector(4 downto 0);  
          IdEx_sturinstruct_out       : out std_logic_vector(10 downto 0)
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

component AND2 is
port (
      in0    : in  STD_LOGIC;
      in1    : in  STD_LOGIC_VECTOR(63 downto 0);
      output : out STD_LOGIC;
	debug_equal :out STD_LOGIC -- in0 and in1
);
end component;



component SignExtend is
PORT (
x:  in STD_LOGIC_VECTOR(31 downto 0);
y: out STD_LOGIC_VECTOR(63 downto 0)); -- sign-extend(x)
end component;

component ShiftLeft2 is -- Shifts the input by 2 bits
port(
     x : in  STD_LOGIC_VECTOR(63 downto 0);
     y : out STD_LOGIC_VECTOR(63 downto 0) -- x << 2
);
end component;


component ExMem is 
port(
		  clk              : in std_logic;
          ExMem_Reg2Loc_in   : in STD_LOGIC;
          ExMem_CBranch_in  : in STD_LOGIC;
          ExMem_MemRead_in  : in STD_LOGIC;
          ExMem_MemtoReg_in : in STD_LOGIC;
          ExMem_MemWrite_in : in STD_LOGIC;
          ExMem_RegWrite_in : in STD_LOGIC;
          ExMem_UBranch_in  : in STD_LOGIC;
	  ExMem_Rd_in       : in std_logic_vector(4 downto 0);
          ExMem_Addressin_in    : in STD_LOGIC_VECTOR (63 downto 0); 
          ExMem_Zero_in     : in STD_LOGIC;     
          ExMem_Aluresult_in       : in std_logic_vector(63 downto 0);   
          ExMem_RD2_in       : in std_logic_vector(63 downto 0);  
          ExMem_instruction5_in       : in std_logic_vector(4 downto 0);        
          ExMem_Reg2Loc       : out STD_LOGIC;
          ExMem_CBranch     : out STD_LOGIC;
          ExMem_MemRead     : out STD_LOGIC;
          ExMem_MemtoReg    : out STD_LOGIC;
          ExMem_MemWrite    : out STD_LOGIC;
          ExMem_RegWrite    : out STD_LOGIC;
          ExMem_UBranch     : out STD_LOGIC;
          ExMem_Addressin    : out STD_LOGIC_VECTOR (63 downto 0); 
          ExMem_Zero     : out STD_LOGIC;     
          ExMem_Aluresult       : out std_logic_vector(63 downto 0);   
          ExMem_RD2      : out std_logic_vector(63 downto 0);  
	  ExMem_Rd_out       : out std_logic_vector(4 downto 0);
          ExMem_instruction5       : out std_logic_vector(4 downto 0)
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
     in0       : in     STD_LOGIC_VECTOR(63 downto 0);
     in1       : in     STD_LOGIC_VECTOR(63 downto 0);
     operation : in     STD_LOGIC_VECTOR(3 downto 0);
     result    : buffer STD_LOGIC_VECTOR(63 downto 0);
     zero      : buffer STD_LOGIC;
     overflow  : buffer STD_LOGIC
    );
end component;

component Hazarddetect is
port(
	 hazard_idex_Rd   : in  STD_LOGIC_VECTOR(4 downto 0);
	 hazard_Rn        : in  STD_LOGIC_VECTOR(4 downto 0);
	 hazard_Rm  	  : in  STD_LOGIC_VECTOR(4 downto 0);
     hazard_idex_Memread   : in STD_LOGIC;


     PCWrite  	: out STD_LOGIC;
     IfIdwrite  : out STD_LOGIC;
     selection	    : out STD_LOGIC

);
end component;

component Forwarding is
port(
	 forwarding_Rn    : in  STD_LOGIC_VECTOR(4 downto 0);
	 forwarding_Rm	  : in  STD_LOGIC_VECTOR(4 downto 0);
	 forwarding_exmem_Rd    : in  STD_LOGIC_VECTOR(4 downto 0);
	 forwarding_memwb_Rd    : in  STD_LOGIC_VECTOR(4 downto 0);
     forwarding_exmem_regwrite   : in STD_LOGIC;
     forwarding_memwb_regwrite   : in STD_LOGIC;
	 forwarding_sturinstruct   : in  STD_LOGIC_VECTOR(10 downto 0);
	 forwarding_Rd    : in  STD_LOGIC_VECTOR(4 downto 0);

     ForwardA  	: out STD_LOGIC_VECTOR(1 downto 0);
     ForwardB   : out STD_LOGIC_VECTOR(1 downto 0);

     ForwardC   : out STD_LOGIC

);
end component;


component DMEM is
-- The data memory is a byte addressble, big-endian, read/write memory with a single address port
-- It may not read and write at the same time
generic(NUM_BYTES : integer := 144);
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

component MemWb is 
port(
		  clk              : in std_logic;
          MemWb_MemWtoReg_in : in STD_LOGIC;
          MemWb_RegWrite_in : in STD_LOGIC; 
          MemWb_Aluresult_in       : in std_logic_vector(63 downto 0);   
          MemWb_RD_in       : in std_logic_vector(63 downto 0);         
          MemWb_instruction5_in       : in std_logic_vector(4 downto 0);
	  MemWb_Rd_in1       : in std_logic_vector(4 downto 0);      
		 
          MemWb_MemWtoReg : out STD_LOGIC;
          MemWb_RegWrite : out STD_LOGIC; 
          MemWb_Aluresult       : out std_logic_vector(63 downto 0);   
          MemWb_RD      : out std_logic_vector(63 downto 0);  
	  MemWb_Rd_out       : out std_logic_vector(4 downto 0);
          MemWb_instruction5       : out std_logic_vector(4 downto 0)
		  );      		  
          
end component;



component MUX64_3select1 is 
port(
    in0    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 00
    in1    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 01
    in2    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 10
    sel    : in STD_LOGIC_VECTOR(1 downto 0);
    output : out STD_LOGIC_VECTOR(63 downto 0)
);
end component;

component OR2 is
port (
in0 : in STD_LOGIC;
in1 : in STD_LOGIC;
output : out STD_LOGIC 
);
end component;

component cbz is

port(
     in0    : std_logic_vector(63 downto 0);
	 iscbz  : in STD_LOGIC; 
	 iscontrol  : in STD_LOGIC;  
     output : out STD_LOGIC
);
end component;


signal IdEx_pc,IdEx_RD2, IdEx_RD1,WD, add4output, PCIn, PCAddressOut, RD1, RD2, Signextendout, sleft2,
 Second_addout, ALUin, ALUresult, ExMem_Addressin, ExMem_Aluresult, ExMem_RD2, ReadData, MemWb_Aluresult, 
MemWb_RD, IdEx_signextend,IfId_pc_out,PCAddressIn,MUX64_31B,MUX64_31A,cbzrd:STD_LOGIC_VECTOR(63 downto 0);
signal Reg2Loc,Reg2Lock,CBranch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite,UBranch, PCSrc, MemWb_RegWrite, 
IdEx_Reg2Loc,IdEx_CBranch,IdEx_MemRead,IdEx_MemtoReg,IdEx_MemWrite,IdEx_ALUSrc,IdEx_RegWrite,IdEx_UBranch,
 zero, overflow, ExMem_Reg2Loc, ExMem_CBranch,ExMem_MemRead, ExMem_MemtoReg,ExMem_MemWrite,ExMem_RegWrite,ExMem_UBranch,
 ExMem_Zero, MemWb_MemWtoReg,and2out,ifid_write,PCwrite_enable,selection,branch,ForwardC1,controlchoice,cbzresult,ifflush:STD_LOGIC;

signal instruction,IfId_instruction_out:STD_LOGIC_VECTOR(31 downto 0);
signal ALUOp, IdEx_ALUOp:STD_LOGIC_VECTOR(1 downto 0);
signal ForwardAsel,ForwardBsel:STD_LOGIC_VECTOR(1 downto 0);
signal MemWb_Rd_out,ExMem_Rd_out,IdEx_Rd_out, IdEx_Rn_out,IdEx_Rm_out,mux5out,RR2, WR, ExMem_instruction5,RR1,  IdEx_instruction5:STD_LOGIC_VECTOR(4 downto 0);
signal ALUcontrolout:STD_LOGIC_VECTOR(3 downto 0);

signal PCadd4:STD_LOGIC_VECTOR(63 downto 0):="0000000000000000000000000000000000000000000000000000000000000100";
signal IdEx_instruction11,IdEx_sturinstruct_out:STD_LOGIC_VECTOR(10 downto 0);

begin
U1: MUX64 port map(in0=>add4output,in1=>Second_addout,sel=>branch,output=>PCAddressIn);   
U2: PC port map(clk=>clk,PCWrite=>PCwrite_enable,rst=>rst,AddressIn=>PCAddressIn,AddressOut=>PCAddressOut);  
U3: ADD port map(in0=>PCAddressOut,in1=>PCadd4,output=>add4output);   -- pc+4
U4: IMEM port map(Address=>PCAddressOut,ReadData=>instruction);   --imem
U5: IfId port map(ifflush=>branch,IfIdWrite=>ifid_write,clk=>clk,IfId_instruction_in =>instruction,IfId_pc_in=>PCAddressOut,IfId_instruction_out=>IfId_instruction_out,IfId_pc_out=>IfId_pc_out);   --IfId
U6: MUX5 port map(in0=>IfId_instruction_out(20 downto 16),in1=>IfId_instruction_out(4 downto 0),sel=>IfId_instruction_out(28),output=>mux5out);   
U7: registers port map(RR1=>IfId_instruction_out(9 downto 5),RR2=>mux5out,WR=>WR,WD=>WD,RegWrite=>MemWb_RegWrite,Clock=>clk,RD1=>RD1,RD2=>RD2,DEBUG_TMP_REGS =>DEBUG_TMP_REGS,DEBUG_SAVED_REGS=>DEBUG_SAVED_REGS );   
U8: SignExtend port map(x=>IfId_instruction_out(31 downto 0),y=>signextendout);   

U9: CPUControl port map(CBZresult=>cbzresult,ifflush=>ifflush,Control=>selection ,Opcode=>IfId_instruction_out(31 downto 21),
CBranch=>CBranch,MemRead=>MemRead,MemWrite=>MemWrite,ALUSrc=>ALUSrc,RegWrite=>RegWrite,UBranch=>UBranch,ALUOp=>ALUOp,MemtoReg=>MemtoReg);   --control

U10: IdEx port map(IdEx_sturinstruct_in=>IfId_instruction_out(31 downto 21),IdEx_sturinstruct_out =>IdEx_sturinstruct_out , IdEx_Rn_in=>IfId_instruction_out(9 downto 5),IdEx_Rm_in=>IfId_instruction_out(20 downto 16),IdEx_Rd_in=>IfId_instruction_out(4 downto 0),IdEx_Rn_out=>IdEx_Rn_out,IdEx_Rm_out=>IdEx_Rm_out,IdEx_Rd_out=>IdEx_Rd_out,clk=>clk,IdEx_Reg2Loc_in=>Reg2Loc,IdEx_CBranch_in=>CBranch,IdEx_MemRead_in=>MemRead,IdEx_MemtoReg_in=>MemtoReg,IdEx_MemWrite_in=>MemWrite,
IdEx_ALUSrc_in=>ALUSrc,IdEx_RegWrite_in=>RegWrite,IdEx_UBranch_in=>UBranch,IdEx_ALUOp_in=>ALUOp, IdEx_RD1_in=>RD1,IdEx_RD2_in=>RD2,IdEx_pc_in=>IfId_pc_out,IdEx_signextend_in=>Signextendout, 
IdEx_instruction11_in=>IfId_instruction_out(31 downto 21),IdEx_instruction5_in=>IfId_instruction_out(4 downto 0), 
IdEx_Reg2Loc=>IdEx_Reg2Loc,IdEx_CBranch=>IdEx_CBranch,IdEx_MemRead=>IdEx_MemRead,IdEx_MemtoReg=>IdEx_MemtoReg,IdEx_MemWrite=>IdEx_MemWrite, IdEx_ALUSrc=>IdEx_ALUSrc,IdEx_RegWrite=>IdEx_RegWrite,IdEx_UBranch=>IdEx_UBranch,IdEx_ALUOp=>IdEx_ALUOp, IdEx_RD1=>IdEx_RD1,IdEx_RD2=>IdEx_RD2,IdEx_pc=>IdEx_pc,IdEx_signextend=>IdEx_signextend, 
IdEx_instruction11=>IdEx_instruction11,IdEx_instruction5=>IdEx_instruction5);   --IdEx
U11: ShiftLeft2 port map(x=>signextendout,y=>sleft2);   --SL2
U12: ADD port map(in0=>IfId_pc_out,in1=>sleft2,output=>Second_addout);   --Second add 
U13: MUX64 port map(in0=>MUX64_31B,in1=>IdEx_signextend,sel=>IdEx_ALUSrc,output=>ALUin); 
U14: ALUControl port map(ALUOp=>IdEx_ALUOp,Opcode=>IdEx_instruction11,Operation=>ALUcontrolout);   --ALUControl
U15: ALU port map(in0=>MUX64_31A,in1=>ALUin,operation=>ALUcontrolout,result=>ALUresult,zero=>zero,overflow=>overflow);   --ALU
U16: ExMem port map(ExMem_Rd_out=>ExMem_Rd_out,ExMem_Rd_in=>IdEx_Rd_out,clk=>clk,ExMem_Reg2Loc_in=>IdEx_Reg2Loc,ExMem_CBranch_in=>IdEx_CBranch,
ExMem_MemRead_in=>IdEx_MemRead,ExMem_MemtoReg_in=>IdEx_MemtoReg,ExMem_MemWrite_in=>IdEx_MemWrite, 
ExMem_RegWrite_in=>IdEx_RegWrite,ExMem_UBranch_in=>IdEx_UBranch,ExMem_Addressin_in=>Second_addout,ExMem_Zero_in=>zero, 
ExMem_Aluresult_in=>ALUresult,ExMem_RD2_in=>MUX64_31B,ExMem_instruction5_in=>IdEx_instruction5, ExMem_Reg2Loc=>ExMem_Reg2Loc, 
ExMem_CBranch=>ExMem_CBranch,ExMem_MemRead=>ExMem_MemRead, ExMem_MemtoReg=>ExMem_MemtoReg,ExMem_MemWrite=>ExMem_MemWrite,
ExMem_RegWrite=>ExMem_RegWrite,ExMem_UBranch=>ExMem_UBranch, 
ExMem_Addressin=>ExMem_Addressin, ExMem_Zero=>ExMem_Zero,ExMem_Aluresult=>ExMem_Aluresult,ExMem_RD2=>ExMem_RD2,ExMem_instruction5=>ExMem_instruction5);   
U17: DMEM port map(WriteData=>ExMem_RD2,Address=>ExMem_Aluresult,MemRead=>ExMem_MemRead,MemWrite=>ExMem_MemWrite,Clock=>clk,ReadData=>ReadData,DEBUG_MEM_CONTENTS=>DEBUG_MEM_CONTENTS);   --DMEM
U18: MemWb port map(MemWb_Rd_in1=>ExMem_Rd_out, MemWb_Rd_out=>MemWb_Rd_out,clk=>clk, MemWb_instruction5_in=>ExMem_instruction5, MemWb_MemWtoReg_in=>ExMem_MemtoReg,
MemWb_RegWrite_in=>ExMem_RegWrite,MemWb_Aluresult_in=>ExMem_Aluresult,MemWb_RD_in=>ReadData,MemWb_RD=>MemWb_RD,
MemWb_MemWtoReg=>MemWb_MemWtoReg, MemWb_RegWrite=>MemWb_RegWrite, MemWb_Aluresult=>MemWb_Aluresult, MemWb_instruction5 =>WR); 
U19: MUX64 port map(in0=>MemWb_Aluresult,in1=>MemWb_RD,sel=>MemWb_MemWtoReg,output=>WD);  
U20: AND2 port map(in0=>CBranch,in1=>RD2,output=>PCSrc,debug_equal=>DEBUG_REG_EQUAL);  
U21: Hazarddetect port map(
hazard_idex_Rd=>IdEx_Rd_out,hazard_Rn=>IfId_instruction_out(9 downto 5),hazard_Rm=>IfId_instruction_out(20 downto 16),
hazard_idex_Memread=>IdEx_MemRead,selection=>selection,IfIdwrite=>ifid_write,PCWrite=>PCwrite_enable); 
U22: Forwarding port map(forwarding_Rd=>IdEx_Rd_out,forwarding_sturinstruct=>IdEx_sturinstruct_out,forwarding_Rn=>IdEx_Rn_out,
forwarding_Rm=>IdEx_Rm_out,forwarding_exmem_Rd=>ExMem_Rd_out,forwarding_memwb_Rd=>MemWb_Rd_out, forwarding_exmem_regwrite=>ExMem_RegWrite,
forwarding_memwb_regwrite=>MemWb_RegWrite, ForwardA=>ForwardAsel,ForwardB=>ForwardBsel, ForwardC=>ForwardC1);   
U23: MUX64_3select1 port map(in0=>IdEx_RD1,in1=>WD,in2=>ExMem_Aluresult,sel=>ForwardAsel,output=>MUX64_31A); 
U24: MUX64_3select1  port map(in0=>IdEx_RD2,in1=>WD,in2=>ExMem_Aluresult,sel=>ForwardBsel,output=>MUX64_31B); 
U25: OR2 port map(in0=>PCSrc,in1=>UBranch,output=>branch); 
--U26: MUX64 port map(in0=>RD2,in1=>ExMem_Aluresult,sel=>ForwardC1,output=>cbzrd); 
--U27: cbz port map(iscontrol=> controlchoice,iscbz=>CBranch ,in0=>cbzrd,output=>cbzresult); 

---u21 orgate port map
RR1<=IfId_instruction_out(9 downto 5);
RR2<=mux5out;

Reg2Lock<=IfId_instruction_out(28);
DEBUG_IF_FLUSH <=branch;
DEBUG_PC<=PCAddressOut;
DEBUG_INSTRUCTION <=instruction;
DEBUG_FORWARDA <= ForwardAsel;
DEBUG_FORWARDB <= ForwardBsel;
DEBUG_PC_WRITE_ENABLE <= PCWrite_enable;

end;






