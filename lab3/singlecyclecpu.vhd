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

architecture behv_SingleCycleCPU of SingleCycleCPU is

component AND2 is
port (
      in0    : in  STD_LOGIC;
      in1    : in  STD_LOGIC;
      output : out STD_LOGIC -- in0 and in1
);
end component;

component ORgate is
port(
     in0    : in  STD_LOGIC;
     in1    : in  STD_LOGIC;
     output : out STD_LOGIC
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

component MUX64 is 
port(
    in0    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 0
    in1    : in STD_LOGIC_VECTOR(63 downto 0); -- sel == 1
    sel    : in STD_LOGIC; -- selects in0 or in1
    output : out STD_LOGIC_VECTOR(63 downto 0)
);
end component;

component ShiftLeft2 is -- Shifts the input by 2 bits
port(
     x : in  STD_LOGIC_VECTOR(63 downto 0);
     y : out STD_LOGIC_VECTOR(63 downto 0) -- x << 2
);
end component;

component SignExtend is
port(
     x : in  STD_LOGIC_VECTOR(31 downto 0);
     y : out STD_LOGIC_VECTOR(63 downto 0) -- sign-extend(x)
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
     Opcode    : in   STD_LOGIC_VECTOR(10 downto 0);
     Operation : out STD_LOGIC_VECTOR(3 downto 0)
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
generic(NUM_BYTES : integer := 32);
port(RR1      : in  STD_LOGIC_VECTOR (4 downto 0); 
     RR2      : in  STD_LOGIC_VECTOR (4 downto 0); 
     WR       : in  STD_LOGIC_VECTOR (4 downto 0); 
     WD       : in  STD_LOGIC_VECTOR (63 downto 0);
     RegWrite : in  STD_LOGIC;
     Clock    : in  STD_LOGIC;
     RD1      : out STD_LOGIC_VECTOR (63 downto 0);
     RD2      : out STD_LOGIC_VECTOR (63 downto 0);
     DEBUG_TMP_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
     DEBUG_SAVED_REGS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)
);
end component;

component IMEM is
generic(NUM_BYTES : integer := 64);
port(
     Address  : in  STD_LOGIC_VECTOR(63 downto 0); -- Address to read from
     ReadData : out STD_LOGIC_VECTOR(31 downto 0)
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

signal add4out,pcout,RD1,RD2,WD,signextendout,slout,addslout,aluin,aluresult,dmemout,pcin:STD_LOGIC_VECTOR(63 downto 0);
signal andout,orout,zero,CBranch,UBranch,Reg2Loc,MemRead,MemtoReg,MemWrite,ALUSrc,RegWrite:STD_LOGIC;
signal ALUOp:STD_LOGIC_VECTOR(1 downto 0);
signal instruction:STD_LOGIC_VECTOR(31 downto 0);
signal mux5out:STD_LOGIC_VECTOR(4 downto 0);
signal aluctrlout:STD_LOGIC_VECTOR(3 downto 0);  
signal PC4:STD_LOGIC_VECTOR(63 downto 0):="0000000000000000000000000000000000000000000000000000000000000100";
signal write_enable:STD_LOGIC:='1';

begin

U0: AND2 port map(in0 => CBranch,in1 => zero,output => andout);
U1: ORgate port map(in0 => UBranch, in1 => andout, output => orout);
U2: MUX5 port map(in0 => instruction(20 downto 16),in1 => instruction(4 downto 0),sel => Reg2Loc,output => mux5out);
U3: MUX64 port map(in0 => RD2,in1 => signextendout,sel => ALUSrc,output => aluin);
U4: MUX64 port map(in0 => aluresult,in1 => dmemout,sel => MemtoReg,output => WD);
U5: MUX64 port map(in0 => add4out,in1 => addslout,sel => orout,output => pcin);
U6: ShiftLeft2 port map(x => signextendout,y => slout);
U7: SignExtend port map(x => instruction(31 downto 0),y => signextendout);
U8: PC port map(clk => clk,write_enable => write_enable,rst => rst,AddressIn => pcin,AddressOut=>pcout);
U9: ADD port map(in0 => pcout,in1 => slout,output => addslout);
U10: ADD port map(in0 => pcout,in1 => PC4,output => add4out);
U11: ALU port map(in0 => RD1,in1 => aluin,operation => aluctrlout,result => aluresult,zero => zero,overflow => open);
U12: ALUControl port map(ALUOp => ALUOp,Opcode => instruction(31 downto 21),Operation => aluctrlout);
U13: CPUControl port map(Opcode => instruction(31 downto 21),Reg2Loc => Reg2Loc,CBranch => CBranch,MemRead => MemRead,MemWrite => MemWrite,ALUSrc => ALUSrc,RegWrite => RegWrite,UBranch => UBranch,ALUOp => ALUOp,MemtoReg => MemtoReg);
U14: registers port map(RR1 => instruction(9 downto 5),RR2 => mux5out,WR => instruction(4 downto 0),WD => WD,RegWrite => RegWrite,Clock => clk,RD1 => RD1,RD2 => RD2);
U15: IMEM port map(Address => pcout,ReadData => instruction);
U16: DMEM port map(WriteData => RD2,Address => aluresult,MemRead => MemRead,MemWrite => MemWrite,Clock => clk,ReadData => dmemout);

end behv_SingleCycleCPU;  


