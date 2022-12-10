library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CPUControl is
port(
     Control  : in STD_LOGIC;
     Opcode   : in  STD_LOGIC_VECTOR(10 downto 0);
     --Reg2Loc   : out STD_LOGIC;
     CBranch  : out STD_LOGIC;
     MemRead  : out STD_LOGIC;
     MemtoReg : out STD_LOGIC;
     MemWrite : out STD_LOGIC;
     ALUSrc   : out STD_LOGIC;
     RegWrite : out STD_LOGIC;
     UBranch     : out STD_LOGIC;
     ifflush  : out STD_LOGIC;
     CBZresult : in STD_LOGIC;
     ALUOp    : out STD_LOGIC_VECTOR(1 downto 0)
);
end CPUControl;


architecture CPUControl_example of CPUControl is
begin
	process(Opcode,Control,CBZresult)
	begin
	if(CBZresult='1') then
	ifflush<='1';
	end if;

	if(Control='1') then
		if (Opcode(10)='1' AND Opcode(7 downto 5)="100" AND Opcode(2 downto 1) ="00") then 
			
			ALUSrc <='1';
			MemtoReg <='0';
			RegWrite <='1';
			MemRead <='0';
			MemWrite <='0';
			CBranch <='0';
			UBranch <='0';
			ALUOp <="10";
		elsif (Opcode(10)='1' AND Opcode(7 downto 4)="0101" AND Opcode(2 downto 0) ="000") then 
			
			ALUSrc <='0';
			MemtoReg <='0';
			RegWrite <='1';
			MemRead <='0';
			MemWrite <='0';
			CBranch <='0';
			UBranch <='0';
			ALUOp <="10";
		elsif (Opcode(10 downto 2) ="110100110") then 
			
			ALUSrc <='1';
			MemtoReg <='0';
			RegWrite <='1';
			MemRead <='0';
			MemWrite <='0';
			CBranch <='0';
			UBranch <='0';
			ALUOp <="10";
		elsif (Opcode ="11111000010") then 
			
			ALUSrc <='1';
			MemtoReg <='1';
			RegWrite <='1';
			MemRead <='1';
			MemWrite <='0';
			CBranch <='0';
			UBranch <='0';
			ALUOp <="00";
		elsif (Opcode="11111000000") then 
			
			ALUSrc <='1';
			MemtoReg <='X';
			RegWrite <='0';
			MemRead <='0';
			MemWrite <='1';
			CBranch <='0';
			UBranch <='0';
			ALUOp <="00";
		elsif (Opcode(10 downto 3) ="10110100") then 
			
			ALUSrc <='0';
			MemtoReg <='X';
			RegWrite <='0';
			MemRead <='0';
			MemWrite <='0';
			CBranch <='1';
			UBranch <='0';
			ALUOp <="01"; 
		elsif (Opcode(10 downto 3) ="10110101") then 
			
			ALUSrc <='0';
			MemtoReg <='X';
			RegWrite <='0';
			MemRead <='0';
			MemWrite <='0';
			CBranch <='1';
			UBranch <='0';
			ALUOp <="01"; 
		elsif (Opcode(10 downto 5)= "000101") then --UBranch
			
			ALUSrc <='X';
			MemtoReg <='X';
			RegWrite <='0';
			MemRead <='X';
			MemWrite <='0';
			CBranch <='X';
			UBranch <='1';
			ALUOp <="XX"; 
		else
			
			ALUSrc <='X';
			MemtoReg <='X';
			RegWrite <='X';
			MemRead <='X';
			MemWrite <='X';
			CBranch <='X';
			UBranch <='X';
			ALUOp <="11"; 
		end if;
	elsif(Control='0') then
        	 ALUSrc <= '0'; MemtoReg <= '0'; RegWrite <= '0'; MemRead <= '0'; MemWrite <= '0'; CBranch <= '0'; UBranch <= '0'; ALUOp <= "00"; 
	end if;
	end process;
end CPUControl_example;
