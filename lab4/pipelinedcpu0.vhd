library ieee;  
use ieee.std_logic_1164.all; 
use IEEE.std_logic_signed.all;
use ieee.numeric_std.all;
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

architecture behv_cpu of PipelinedCPU0 is

component MUX64 is
port(
	in0    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 0
    	in1    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 1
    	sel    : in STD_LOGIC; -- select in0 or in1
    	output : out STD_LOGIC_VECTOR(63 downto 0)
);
end component;

component PC is
port(
     clk          : in  STD_LOGIC; -- Propogate AddressIn to AddressOut on rising edge of clock
     write_enable : in  STD_LOGIC; -- Only write if '1'
     rst          : in  STD_LOGIC; -- Asynchronous reset! Sets AddressOut to 0x0
     AddressIn    : in  STD_LOGIC_VECTOR(63 downto 0); -- Next PC address
     AddressOut   : out STD_LOGIC_VECTOR(63 downto 0) -- Current PC address
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
     Address  : in  STD_LOGIC_VECTOR(63 downto 0); -- Address to read from
     ReadData : out STD_LOGIC_VECTOR(31 downto 0)
);
end component;

component IFID
port(
	clk	 : in  STD_LOGIC;
	write_enable : in  STD_LOGIC; -- Only write if '1'
        rst          : in  STD_LOGIC;
	ifid_pcin: in  STD_LOGIC_VECTOR(63 downto 0);
	ifid_imin: in  STD_LOGIC_VECTOR(31 downto 0);
	ifid_pcout: out  STD_LOGIC_VECTOR(63 downto 0);
	ifid_imout: out  STD_LOGIC_VECTOR(31 downto 0)
);
end component;

component MUX5 is
port(
    in0    : in STD_LOGIC_VECTOR(4 downto 0); -- sel == 0
    in1    : in STD_LOGIC_VECTOR(4 downto 0); -- sel == 1
    sel    : in STD_LOGIC; -- selects in0 or in1
    output : out STD_LOGIC_VECTOR(4 downto 0)
);
end component;

component CPUControl is
port(Opcode   : in  STD_LOGIC_VECTOR(10 downto 0);
     Reg2Loc  : out STD_LOGIC;	
     CBranch  : out STD_LOGIC;  --conditional
     MemRead  : out STD_LOGIC;
     MemtoReg : out STD_LOGIC;
     MemWrite : out STD_LOGIC;
     ALUSrc   : out STD_LOGIC;
     RegWrite : out STD_LOGIC;
     UBranch  : out STD_LOGIC; -- This is unconditional
     ALUOp    : out STD_LOGIC_VECTOR(1 downto 0)
);
end component;

component registers is
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
     x : in  STD_LOGIC_VECTOR(31 downto 0);
     y : out STD_LOGIC_VECTOR(63 downto 0) -- sign-extend(x)
);
end component;

component IDEX is
port(
	  clk              : in STD_LOGIC;
	  IDEX_Reg2Loc_in  : in STD_LOGIC;
          IDEX_CBranch_in  : in STD_LOGIC;
          IDEX_MemRead_in  : in STD_LOGIC;
          IDEX_MemtoReg_in : in STD_LOGIC;
          IDEX_MemWrite_in : in STD_LOGIC;
          IDEX_ALUSrc_in   : in STD_LOGIC;
          IDEX_RegWrite_in : in STD_LOGIC;
          IDEX_UBranch_in  : in STD_LOGIC;
          IDEX_ALUOp_in    : in STD_LOGIC_VECTOR(1 downto 0);
          IDEX_RD1_in       : in STD_LOGIC_VECTOR (63 downto 0); 
          IDEX_RD2_in       : in STD_LOGIC_VECTOR (63 downto 0);       
          IDEX_pc_in       : in std_logic_vector(63 downto 0);   
          IDEX_signextend_in       : in std_logic_vector(63 downto 0);  
          IDEX_instr11_in       : in std_logic_vector(10 downto 0);  
          IDEX_instr5_in       : in std_logic_vector(4 downto 0);        
          IDEX_Reg2Loc	   : out STD_LOGIC;
          IDEX_CBranch     : out STD_LOGIC;
          IDEX_MemRead     : out STD_LOGIC;
          IDEX_MemtoReg    : out STD_LOGIC;
          IDEX_MemWrite    : out STD_LOGIC;
          IDEX_ALUSrc      : out STD_LOGIC;
          IDEX_RegWrite    : out STD_LOGIC;
          IDEX_UBranch     : out STD_LOGIC;
          IDEX_ALUOp       : out STD_LOGIC_VECTOR(1 downto 0);
          IDEX_RD1          : out STD_LOGIC_VECTOR (63 downto 0); 
          IDEX_RD2          : out STD_LOGIC_VECTOR (63 downto 0);
          IDEX_pc       : out std_logic_vector(63 downto 0);  
          IDEX_signextend       : out std_logic_vector(63 downto 0);  
          IDEX_instr11       : out std_logic_vector(10 downto 0);  
          IDEX_instr5       : out std_logic_vector(4 downto 0)
);   
end component;

component ShiftLeft2 is -- Shifts the input by 2 bits
port(
     x : in  STD_LOGIC_VECTOR(63 downto 0);
     y : out STD_LOGIC_VECTOR(63 downto 0) -- x << 2
);
end component;

component ALU is
port(
     in0       : in     STD_LOGIC_VECTOR(63 downto 0);
     in1       : in     STD_LOGIC_VECTOR(63 downto 0);
     operation : in     STD_LOGIC_VECTOR(3 downto 0);
     result    : buffer STD_LOGIC_VECTOR(63 downto 0);
     zero      : buffer STD_LOGIC;
     overflow  : buffer STD_LOGIC
    );
end component;

component ALUControl is
port(
     ALUOp     : in  STD_LOGIC_VECTOR(1 downto 0);
     Opcode    : in  STD_LOGIC_VECTOR(10 downto 0);
     Operation : out STD_LOGIC_VECTOR(3 downto 0)
    );
end component;

component ExMem
port(
 	  clk              :  in STD_LOGIC;
	  ExMem_Reg2Loc_in  : in STD_LOGIC;
          ExMem_CBranch_in  : in STD_LOGIC;
          ExMem_MemRead_in  : in STD_LOGIC;
          ExMem_MemtoReg_in : in STD_LOGIC;
          ExMem_MemWrite_in : in STD_LOGIC;
          ExMem_RegWrite_in : in STD_LOGIC;
          ExMem_UBranch_in  : in STD_LOGIC;
          ExMem_Addin       : in STD_LOGIC_VECTOR (63 downto 0); 
          ExMem_Zero_in     : in STD_LOGIC;     
          ExMem_Aluresult_in       : in std_logic_vector(63 downto 0);   
          ExMem_RD2_in       : in std_logic_vector(63 downto 0);  
          ExMem_instr5_in       : in std_logic_vector(4 downto 0);   
	  ExMem_Reg2Loc	    : out STD_LOGIC;
          ExMem_CBranch     : out STD_LOGIC;
          ExMem_MemRead     : out STD_LOGIC;
          ExMem_MemtoReg    : out STD_LOGIC;
          ExMem_MemWrite    : out STD_LOGIC;
          ExMem_RegWrite    : out STD_LOGIC;
          ExMem_UBranch     : out STD_LOGIC;
          ExMem_Addout      : out STD_LOGIC_VECTOR (63 downto 0); 
          ExMem_Zero        : out STD_LOGIC;     
          ExMem_Aluresult   : out std_logic_vector(63 downto 0);   
          ExMem_RD2         : out std_logic_vector(63 downto 0);  
          ExMem_instr5      : out std_logic_vector(4 downto 0)
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
generic(NUM_BYTES : integer := 64);
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
          MemWb_MemtoReg_in : in STD_LOGIC;
          MemWb_RegWrite_in : in STD_LOGIC; 
          MemWb_Aluresult_in       : in std_logic_vector(63 downto 0);   
          MemWb_RD_in       : in std_logic_vector(63 downto 0);         
          MemWb_instr5_in       : in std_logic_vector(4 downto 0);      
		 
          MemWb_MemtoReg : out STD_LOGIC;
          MemWb_RegWrite : out STD_LOGIC; 
          MemWb_Aluresult       : out std_logic_vector(63 downto 0);   
          MemWb_RD       : out std_logic_vector(63 downto 0);  
          MemWb_instr5       : out std_logic_vector(4 downto 0)
);      		  
end component;

signal PC_write_enable :STD_LOGIC:='1';
signal ALUOp, IDEX_ALUOp :STD_LOGIC_VECTOR(1 downto 0);
signal ALUCtrl_Out :STD_LOGIC_VECTOR(3 downto 0);
signal Read_register2, WR, ExMem_instr5,  IDEX_instr5:STD_LOGIC_VECTOR(4 downto 0);
signal IDEX_instr11 :STD_LOGIC_VECTOR(10 downto 0);
signal IM_Out,ifid_imout :STD_LOGIC_VECTOR(31 downto 0);
signal add4 :STD_LOGIC_VECTOR(63 downto 0):= "0000000000000000000000000000000000000000000000000000000000000100";

signal WD,add4_out, PC_In, PC_Out,ifid_pcout, addsl_out, Signextendout, RD1, RD2, IDEX_RD1, IDEX_RD2, IDEX_pc, IDEX_signextend, SL_out, ALU_In, ALUresult, ExMem_Addout, ExMem_Aluresult, ExMem_RD2, MemWb_Aluresult, dmem_out, MemWb_RD :STD_LOGIC_VECTOR(63 downto 0);

signal Reg2Loc,CBranch,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite,UBranch,PCSrc,IDEX_Reg2Loc, IDEX_CBranch, IDEX_MemRead,IDEX_MemtoReg, IDEX_MemWrite, IDEX_ALUSrc,IDEX_RegWrite,IDEX_UBranch, zero, overflow,ExMem_Reg2Loc,ExMem_CBranch, ExMem_MemRead, ExMem_MemtoReg,ExMem_MemWrite, ExMem_RegWrite,ExMem_UBranch, ExMem_Zero, MemWb_RegWrite, MemWb_MemtoReg:STD_LOGIC;

signal TmpReg, SavedReg : STD_LOGIC_VECTOR(64*4-1 downto 0);
signal MEMContents: STD_LOGIC_VECTOR(64*4-1 downto 0);

begin

U1: MUX64 port map(in0 => add4_out, in1 => ExMem_Addout, sel => PCSrc, output => PC_In);

U2: PC port map(clk => clk, write_enable => PC_write_enable, rst => rst, AddressIn => PC_In, AddressOut => PC_Out);

U3: ADD port map(in0 => PC_Out, in1 => add4, output => add4_out);

U4: IMEM port map(Address => PC_Out,ReadData => IM_Out);

U5: IFID port map(clk => clk, rst => rst, write_enable => PC_write_enable, ifid_pcin => PC_Out, ifid_imin=>IM_Out, ifid_pcout => ifid_pcout, ifid_imout=>ifid_imout);

U6: CPUControl port map(Opcode => ifid_imout(31 downto 21), Reg2Loc => Reg2Loc, CBranch => CBranch, MemRead => MemRead, MemtoReg => MemtoReg, MemWrite => MemWrite, ALUSrc => ALUSrc,RegWrite => RegWrite,UBranch => UBranch,ALUOp => ALUOp);

U7: MUX5 port map(in0 => ifid_imout(20 downto 16), in1 => ifid_imout(4 downto 0), sel => ifid_imout(28),output => Read_register2);

U8: registers port map(RR1 => ifid_imout(9 downto 5), RR2 => Read_register2, WR => WR, WD => WD, RegWrite => MemWb_RegWrite, Clock => clk, RD1 => RD1, RD2 => RD2, DEBUG_TMP_REGS => TmpReg, DEBUG_SAVED_REGS => SavedReg);

U9: SignExtend port map(x => ifid_imout, y => Signextendout);

U10: IDEX port map(clk => clk, IDEX_Reg2Loc_in => Reg2Loc, IDEX_CBranch_in => CBranch,IDEX_MemRead_in => MemRead, IDEX_MemtoReg_in => MemtoReg,IDEX_MemWrite_in => MemWrite, 
		   IDEX_ALUSrc_in => ALUSrc,IDEX_RegWrite_in => RegWrite,IDEX_UBranch_in => UBranch, IDEX_ALUOp_in => ALUOp, IDEX_RD1_in=>RD1,
		   IDEX_RD2_in => RD2,IDEX_pc_in => ifid_pcout, IDEX_signextend_in => Signextendout, IDEX_instr11_in => ifid_imout(31 downto 21), 
		   IDEX_instr5_in => ifid_imout(4 downto 0), IDEX_Reg2Loc => IDEX_Reg2Loc, IDEX_CBranch => IDEX_CBranch, IDEX_MemRead =>IDEX_MemRead,IDEX_MemtoReg=>IDEX_MemtoReg,
		   IDEX_MemWrite=>IDEX_MemWrite, IDEX_ALUSrc=>IDEX_ALUSrc,IDEX_RegWrite=>IDEX_RegWrite,IDEX_UBranch=>IDEX_UBranch,IDEX_ALUOp=>IDEX_ALUOp,
		   IDEX_RD1=>IDEX_RD1,IDEX_RD2=>IDEX_RD2,IDEX_pc=>IDEX_pc,IDEX_signextend=>IDEX_signextend, IDEX_instr11=>IDEX_instr11,IDEX_instr5=>IDEX_instr5);

U11: ShiftLeft2 port map(x => IDEX_signextend, y => SL_out);

U12: ADD port map(in0 => IDEX_pc, in1 => SL_out, output => addsl_out);

U13: MUX64 port map(in0 => IDEX_RD2,in1 => IDEX_signextend, sel => IDEX_ALUSrc, output => ALU_In);

U14: ALUControl port map(ALUOp => IDEX_ALUOp, Opcode => IDEX_instr11, Operation => ALUCtrl_Out); 

U15: ALU port map(in0 => IDEX_RD1, in1 => ALU_In, operation => ALUCtrl_Out, result => ALUresult, zero => zero, overflow => overflow);

U16: ExMem port map(clk => clk, ExMem_Reg2Loc_in => IDEX_Reg2Loc, ExMem_CBranch_in => IDEX_CBranch, ExMem_MemRead_in => IDEX_MemRead, ExMem_MemtoReg_in => IDEX_MemtoReg,
	 	    ExMem_MemWrite_in => IDEX_MemWrite, ExMem_RegWrite_in => IDEX_RegWrite, ExMem_UBranch_in => IDEX_UBranch, ExMem_Addin => addsl_out, ExMem_Zero_in => zero,
		    ExMem_Aluresult_in=> ALUresult,ExMem_RD2_in => IDEX_RD2,ExMem_instr5_in => IDEX_instr5, ExMem_Reg2Loc => ExMem_Reg2Loc, ExMem_CBranch => ExMem_CBranch,
		    ExMem_MemRead => ExMem_MemRead, ExMem_MemtoReg => ExMem_MemtoReg, ExMem_MemWrite => ExMem_MemWrite,ExMem_RegWrite => ExMem_RegWrite,ExMem_UBranch=>ExMem_UBranch, 
		    ExMem_Addout => ExMem_Addout, ExMem_Zero => ExMem_Zero,ExMem_Aluresult => ExMem_Aluresult, ExMem_RD2 => ExMem_RD2, ExMem_instr5 => ExMem_instr5); 

U17: AND2 port map(in0 => ExMem_CBranch, in1 => ExMem_Zero, output => PCSrc);



U18: DMEM port map(WriteData => ExMem_RD2, Address => ExMem_Aluresult, MemRead => ExMem_MemRead, MemWrite => ExMem_MemWrite, Clock => clk, ReadData => dmem_out, DEBUG_MEM_CONTENTS => MEMContents); 

U219: MemWb port map(clk => clk, MemWb_RegWrite_in => ExMem_RegWrite, MemWb_MemtoReg_in => ExMem_MemtoReg, MemWb_Aluresult_in=>ExMem_Aluresult,
		    MemWb_RD_in => dmem_out, MemWb_instr5_in => ExMem_instr5, MemWb_MemtoReg=>MemWb_MemtoReg, 
		    MemWb_RegWrite => MemWb_RegWrite, MemWb_Aluresult => MemWb_Aluresult, MemWb_RD => MemWb_RD, MemWb_instr5 => WR);

U20: MUX64 port map(in0 => MemWb_Aluresult, in1 => MemWb_RD, sel => MemWb_MemtoReg, output => WD);

DEBUG_PC <= PC_Out;
DEBUG_INSTRUCTION <= ifid_imout;
DEBUG_TMP_REGS <= TmpReg;
DEBUG_SAVED_REGS <= SavedReg;
DEBUG_MEM_CONTENTS <= MEMContents;


end;
