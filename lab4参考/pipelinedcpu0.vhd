library ieee;  
use ieee.std_logic_1164.all;  

entity PipelinedCPU0 is
port(
     clk : in STD_LOGIC;
     rst : in STD_LOGIC;
     --Probe ports used for testing
     --The current address (AddressOut from the PC)
     DEBUG_PC : out STD_LOGIC_VECTOR(63 downto 0);
     --The current instruction (Instruction output of IMEM)
     DEBUG_INSTRUCTION : out STD_LOGIC_VECTOR(31 downto 0);
     --DEBUG ports from other components
     DEBUG_TMP_REGS     : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
     DEBUG_SAVED_REGS   : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
     DEBUG_MEM_CONTENTS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)
);
end PipelinedCPU0;

architecture structural of PipelinedCPU0 is

component MUX64 is 
port(
    in0    : in STD_LOGIC_VECTOR(63 downto 0); 
    in1    : in STD_LOGIC_VECTOR(63 downto 0); 
    sel    : buffer STD_LOGIC;
    PCSrc  : in STD_LOGIC;
    output : out STD_LOGIC_VECTOR(63 downto 0)
);
end component;

component PC is 
port(
     clk          : in  STD_LOGIC; 
     write_enable : in  STD_LOGIC; 
     rst          : in  STD_LOGIC; 
     AddressIn    : in  STD_LOGIC_VECTOR(63 downto 0); 
     AddressOut   : out STD_LOGIC_VECTOR(63 downto 0); 
     addrbuffer   : buffer STD_LOGIC_VECTOR(63 downto 0) 
);
end component;

component ADD is
port(
     in0    : in  STD_LOGIC_VECTOR(63 downto 0);
     in1    : in  STD_LOGIC_VECTOR(63 downto 0);
     output : out STD_LOGIC_VECTOR(63 downto 0)
);
end component;

component IMEM is
generic(NUM_BYTES : integer := 64);
port(
     Address  : in  STD_LOGIC_VECTOR(63 downto 0); 
     ReadData1 : out STD_LOGIC_VECTOR(31 downto 0)
);
end component;

component IfId is 
port(
          IfId_instr_in        : in std_logic_vector(31 downto 0);
          IfId_pc_in           : in std_logic_vector(63 downto 0);
          clk                  : in std_logic;
          IfId_instr_out_out   : out std_logic_vector(31 downto 0);
          IfId_pc_out_out      : out std_logic_vector(63 downto 0));
end component;

component MUX5 is 
port(
    in0    : in STD_LOGIC_VECTOR(4 downto 0); 
    in1    : in STD_LOGIC_VECTOR(4 downto 0); 
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
     --Probe ports used for testing
     -- $t0 & $t1 & t2 & t3
     DEBUG_TMP_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
     -- $s0 & $s1 & s2 & s3
     DEBUG_SAVED_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)
);
end component;

component SignExtend is
port(
     a : in  STD_LOGIC_VECTOR(3 downto 0);  
     x : in  STD_LOGIC_VECTOR(31 downto 0);
	 z : out STD_LOGIC_VECTOR(63 downto 0); 
     y : out STD_LOGIC_VECTOR(63 downto 0) 
);
end component;

component CPUControl is
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

component IdEx is 
port(
		  clk              : in std_logic;
          IdEx_RegDst_in   : in STD_LOGIC;
          IdEx_CBranch_in  : in STD_LOGIC;
          IdEx_MemRead_in  : in STD_LOGIC;
          IdEx_MemtoReg_in : in STD_LOGIC;
          IdEx_MemWrite_in : in STD_LOGIC;
          IdEx_ALUSrc_in   : in STD_LOGIC;
          IdEx_RegWrite_in : in STD_LOGIC;
          IdEx_UBranch_in  : in STD_LOGIC;
          IdEx_ALUOp_in    : in STD_LOGIC_VECTOR(1 downto 0);
          IdEx_RD1_in       : in STD_LOGIC_VECTOR (63 downto 0); 
          IdEx_RD2_in       : in STD_LOGIC_VECTOR (63 downto 0);       
          IdEx_pc_in       : in std_logic_vector(63 downto 0);   
          IdEx_signextend_in       : in std_logic_vector(63 downto 0);  
          IdEx_instr11_in       : in std_logic_vector(10 downto 0);  
          IdEx_instr5_in       : in std_logic_vector(4 downto 0);        
                 
          IdEx_RegDst      : out STD_LOGIC;
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
          IdEx_instr11       : out std_logic_vector(10 downto 0);  
          IdEx_instr5       : out std_logic_vector(4 downto 0)
);   
end component;

component ShiftLeft2 is
port(
     x : in  STD_LOGIC_VECTOR(63 downto 0);
     y : out STD_LOGIC_VECTOR(63 downto 0) 
);
end component;

component MUX is 
port(
    in0    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 0
    in1    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 1
    sel    : in STD_LOGIC; -- selects in0 or in1
    output : out STD_LOGIC_VECTOR(63 downto 0)
);
end component;

component ALUControl is    
port(
     ALUOp1     : in  STD_LOGIC_VECTOR(1 downto 0);
     Opecode    : in   STD_LOGIC_VECTOR(10 downto 0);
     Operation : out STD_LOGIC_VECTOR(3 downto 0)
);
end component;

component ALU is
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

component ExMem is 
port(
		  clk               : in std_logic;
          ExMem_RegDst_in   : in STD_LOGIC;
          ExMem_CBranch_in  : in STD_LOGIC;
          ExMem_MemRead_in  : in STD_LOGIC;
          ExMem_MemtoReg_in : in STD_LOGIC;
          ExMem_MemWrite_in : in STD_LOGIC;
          ExMem_RegWrite_in : in STD_LOGIC;
          ExMem_UBranch_in  : in STD_LOGIC;
          ExMem_Addin_in    : in STD_LOGIC_VECTOR (63 downto 0); 
          ExMem_Zero_in     : in STD_LOGIC;     
          ExMem_Aluresult_in       : in std_logic_vector(63 downto 0);   
          ExMem_RD2_in      : in std_logic_vector(63 downto 0);  
          ExMem_instr5_in       : in std_logic_vector(4 downto 0);        
     
          ExMem_RegDst      : out STD_LOGIC;
          ExMem_CBranch     : out STD_LOGIC;
          ExMem_MemRead     : out STD_LOGIC;
          ExMem_MemtoReg    : out STD_LOGIC;
          ExMem_MemWrite    : out STD_LOGIC;
          ExMem_RegWrite    : out STD_LOGIC;
          ExMem_UBranch     : out STD_LOGIC;
          ExMem_Addin    : out STD_LOGIC_VECTOR (63 downto 0); 
          ExMem_Zero     : out STD_LOGIC;     
          ExMem_Aluresult       : out std_logic_vector(63 downto 0);   
          ExMem_RD2      : out std_logic_vector(63 downto 0);  
          ExMem_instr5       : out std_logic_vector(4 downto 0)
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
generic(NUM_BYTES : integer := 128);
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
          MemWb_instr5_in       : in std_logic_vector(4 downto 0);      
		 
          MemWb_MemWtoReg : out STD_LOGIC;
          MemWb_RegWrite : out STD_LOGIC; 
          MemWb_Aluresult       : out std_logic_vector(63 downto 0);   
          MemWb_RD       : out std_logic_vector(63 downto 0);  
          MemWb_instr5       : out std_logic_vector(4 downto 0)
		  );   
          
end component;




signal IdEx_pc,IdEx_RD2, IdEx_RD1,WD, Fadd_output, PCAddressIn, PCAddressOut, RD1, RD2, Signextendout, Slout, Sadd_output, ALUin, ALUresult, ExMem_Addin, ExMem_Aluresult, ExMem_RD2, ReadData, MemWb_Aluresult, MemWb_RD, IdEx_signextend,IfId_pc_out_out:STD_LOGIC_VECTOR(63 downto 0);
signal RegDst,CBranch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite,UBranch, PCSrc, MemWb_RegWrite, IdEx_RegDst,IdEx_CBranch,IdEx_MemRead,IdEx_MemtoReg,IdEx_MemWrite,IdEx_ALUSrc,IdEx_RegWrite,IdEx_UBranch, zero, overflow, ExMem_RegDst, ExMem_CBranch,ExMem_MemRead, ExMem_MemtoReg,ExMem_MemWrite,ExMem_RegWrite,ExMem_UBranch, ExMem_Zero, MemWb_MemWtoReg:STD_LOGIC;
signal PCout,IfId_instr_out_out:STD_LOGIC_VECTOR(31 downto 0);
signal ALUOp, IdEx_ALUOp:STD_LOGIC_VECTOR(1 downto 0);
signal Readr, WR, ExMem_instr5,  IdEx_instr5:STD_LOGIC_VECTOR(4 downto 0);
signal ALUcontrolout, a:STD_LOGIC_VECTOR(3 downto 0);
signal PCwrite_enable :STD_LOGIC:='1';
signal Fadd_in1:STD_LOGIC_VECTOR(63 downto 0):="0000000000000000000000000000000000000000000000000000000000000100";
signal IdEx_instr11:STD_LOGIC_VECTOR(10 downto 0);
begin

U1: MUX64 port map(in0=>Fadd_output,in1=>ExMem_Addin,PCSrc=>PCSrc,output=>PCAddressIn);   --before pc
U2: PC port map(clk=>clk,write_enable=>PCwrite_enable,rst=>rst,AddressIn=>PCAddressIn,AddressOut=>PCAddressOut);   --pc
U3: ADD port map(in0=>PCAddressOut,in1=>Fadd_in1,output=>Fadd_output);   --first add (pc+4)
U4: IMEM port map(Address=>PCAddressOut,ReadData1=>PCout);   --imem
U5: IfId port map(clk=>clk,IfId_instr_in=>PCout,IfId_pc_in=>PCAddressOut,IfId_instr_out_out=>IfId_instr_out_out,IfId_pc_out_out=>IfId_pc_out_out);   --IfId
U6: MUX5 port map(in0=>IfId_instr_out_out(20 downto 16),in1=>IfId_instr_out_out(4 downto 0),sel=>IfId_instr_out_out(28),output=>Readr);   --between ifid and register
U7: registers port map(RR1=>IfId_instr_out_out(9 downto 5),RR2=>Readr,WR=>WR,WD=>WD,RegWrite=>MemWb_RegWrite,Clock=>clk,RD1=>RD1,RD2=>RD2);   --register
U8: SignExtend port map(a=>a, x=>IfId_instr_out_out,y=>Signextendout);   --sign-extend
U9: CPUControl port map(Opcode=>IfId_instr_out_out(31 downto 21),RegDst=>RegDst,CBranch=>CBranch,MemRead=>MemRead,MemWrite=>MemWrite,ALUSrc=>ALUSrc,RegWrite=>RegWrite,UBranch=>UBranch,ALUOp=>ALUOp,MemtoReg=>MemtoReg);   --control
U10: IdEx port map(clk=>clk,IdEx_RegDst_in=>RegDst,IdEx_CBranch_in=>CBranch,IdEx_MemRead_in=>MemRead,IdEx_MemtoReg_in=>MemtoReg,IdEx_MemWrite_in=>MemWrite,
IdEx_ALUSrc_in=>ALUSrc,IdEx_RegWrite_in=>RegWrite,IdEx_UBranch_in=>UBranch,IdEx_ALUOp_in=>ALUOp, IdEx_RD1_in=>RD1,IdEx_RD2_in=>RD2,IdEx_pc_in=>IfId_pc_out_out,IdEx_signextend_in=>Signextendout, 
IdEx_instr11_in=>IfId_instr_out_out(31 downto 21),IdEx_instr5_in=>IfId_instr_out_out(4 downto 0), 
IdEx_RegDst=>IdEx_RegDst,IdEx_CBranch=>IdEx_CBranch,IdEx_MemRead=>IdEx_MemRead,IdEx_MemtoReg=>IdEx_MemtoReg,IdEx_MemWrite=>IdEx_MemWrite, IdEx_ALUSrc=>IdEx_ALUSrc,IdEx_RegWrite=>IdEx_RegWrite,IdEx_UBranch=>IdEx_UBranch,IdEx_ALUOp=>IdEx_ALUOp, IdEx_RD1=>IdEx_RD1,IdEx_RD2=>IdEx_RD2,IdEx_pc=>IdEx_pc,IdEx_signextend=>IdEx_signextend, 
IdEx_instr11=>IdEx_instr11,IdEx_instr5=>IdEx_instr5);   --IdEx
U11: ShiftLeft2 port map(x=>IdEx_signextend,y=>Slout);   --ShiftLeft2
U12: ADD port map(in0=>IdEx_pc,in1=>Slout,output=>Sadd_output);   --Second add (afte shift 2)
U13: MUX port map(in0=>IdEx_RD2,in1=>IdEx_signextend,sel=>IdEx_ALUSrc,output=>ALUin);   --mux in ex
U14: ALUControl port map(ALUOp1=>IdEx_ALUOp,Opecode=>IdEx_instr11,Operation=>ALUcontrolout);   --ALUControl
U15: ALU port map(a=>IdEx_RD1,b=>ALUin,operation=>ALUcontrolout,result=>ALUresult,zero=>zero,overflow=>overflow);   --ALU
U16: ExMem port map(clk=>clk,ExMem_RegDst_in=>IdEx_RegDst,ExMem_CBranch_in=>IdEx_CBranch,ExMem_MemRead_in=>IdEx_MemRead,ExMem_MemtoReg_in=>IdEx_MemtoReg,ExMem_MemWrite_in=>IdEx_MemWrite, ExMem_RegWrite_in=>IdEx_RegWrite,ExMem_UBranch_in=>IdEx_UBranch,ExMem_Addin_in=>Sadd_output,ExMem_Zero_in=>zero, ExMem_Aluresult_in=>ALUresult,ExMem_RD2_in=>IdEx_RD2,ExMem_instr5_in=>IdEx_instr5, ExMem_RegDst=>ExMem_RegDst, ExMem_CBranch=>ExMem_CBranch,ExMem_MemRead=>ExMem_MemRead, ExMem_MemtoReg=>ExMem_MemtoReg,ExMem_MemWrite=>ExMem_MemWrite,ExMem_RegWrite=>ExMem_RegWrite,ExMem_UBranch=>ExMem_UBranch, ExMem_Addin=>ExMem_Addin, ExMem_Zero=>ExMem_Zero,ExMem_Aluresult=>ExMem_Aluresult,ExMem_RD2=>ExMem_RD2,ExMem_instr5=>ExMem_instr5);   --ExMem
U17: AND2 port map(in0=>ExMem_CBranch,in1=>ExMem_Zero,output=>PCSrc);   --And gate
U18: DMEM port map(WriteData=>ExMem_RD2,Address=>ExMem_Aluresult,MemRead=>ExMem_MemRead,MemWrite=>ExMem_MemWrite,Clock=>clk,ReadData=>ReadData);   --DMEM
U19: MemWb port map(clk=>clk, MemWb_instr5_in=>ExMem_instr5,MemWb_RD=>MemWb_RD, MemWb_MemWtoReg_in=>ExMem_MemtoReg,MemWb_RegWrite_in=>ExMem_RegWrite,MemWb_Aluresult_in=>ExMem_Aluresult,MemWb_RD_in=>ReadData,MemWb_MemWtoReg=>MemWb_MemWtoReg, MemWb_RegWrite=>MemWb_RegWrite, MemWb_Aluresult=>MemWb_Aluresult, MemWb_instr5 =>WR);   --MemWb
U20: MUX port map(in0=>MemWb_Aluresult,in1=>MemWb_RD,sel=>MemWb_MemWtoReg,output=>WD);   --mux in the end


end;







