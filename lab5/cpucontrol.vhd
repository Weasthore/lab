library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity CPUControl is
-- Functionality should match the truth table shown in Figure 4.22 of the textbook, inlcuding the
--    output 'X' values.
-- The truth table in Figure 4.22 omits the unconditional branch instruction:
--    UBranch = '1'
--    MemWrite = RegWrite = '0'
--    all other outputs = 'X'	
port(
     Control  : in  STD_LOGIC;
     Opcode   : in  STD_LOGIC_VECTOR(10 downto 0);
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
end CPUControl;

architecture BehvCPUC of  CPUControl is

begin
	process(Opcode, Control)
	begin
	if Control = '1' then
		if (Opcode(10) = '1' and Opcode(7 downto 4) = "0101" and Opcode(2 downto 0) = "000") then --R format
			Reg2Loc <= '0';
			CBranch <= '0';
			MemRead <= '0';
			MemtoReg <= '0';
			MemWrite <= '0';
			ALUSrc <= '0';
			RegWrite <= '1';
			UBranch <= '0';
			ALUOp <= "10";

		elsif (Opcode(10 downto 0) = "11111000010") then --LDUR
			Reg2Loc <= 'X';
			CBranch <= '0';
			MemRead <= '1';
			MemtoReg <= '1';
			MemWrite <= '0';
			ALUSrc <= '1';
			RegWrite <= '1';
			UBranch <= '0';
			ALUOp <= "00";
	
		elsif (Opcode(10 downto 0) = "11111000000") then --STUR
			Reg2Loc <= '1';
			CBranch <= '0';
			MemRead <= '0';
			MemtoReg <= 'X';
			MemWrite <= '1';
			ALUSrc <= '1';
			RegWrite <= '0';
			UBranch <= '0';
			ALUOp <= "00";

		elsif (Opcode(10 downto 3) = "10110100") then --CBZ
			Reg2Loc <= '1';
			CBranch <= '1';
			MemRead <= '0';
			MemtoReg <= 'X';
			MemWrite <= '0';
			ALUSrc <= '0';
			RegWrite <= '0';
			UBranch <= '0';
			ALUOp <= "01";
	
		elsif (Opcode(10 downto 3) = "10110101") then --CBNZ
			Reg2Loc <= '1';
			CBranch <= '1';
			MemRead <= '0';
			MemtoReg <= 'X';
			MemWrite <= '0';
			ALUSrc <= '0';
			RegWrite <= '0';
			UBranch <= '0';
			ALUOp <= "01";

		elsif (Opcode(10) = '1' and Opcode(7 downto 5) = "100" and Opcode(2 downto 1) = "00") then --I format
			Reg2Loc <= '0';
			CBranch <= '0';
			MemRead <= '0';
			MemtoReg <= '0';
			MemWrite <= '0';
			ALUSrc <= '1';
			RegWrite <= '1';
			UBranch <= '0';
			ALUOp <= "10";

		elsif (Opcode(10 downto 2) = "110100110") then --LSL,LSR
			Reg2Loc <= '0';
			CBranch <= '0';
			MemRead <= '0';
			MemtoReg <= '0';
			MemWrite <= '0';
			ALUSrc <= '1';
			RegWrite <= '1';
			UBranch <= '0';
			ALUOp <= "10";

		elsif (Opcode(10 downto 5) = "000101") then --UBranch
			Reg2Loc <= 'X';
			CBranch <= 'X';
			MemRead <= 'X';
			MemtoReg <= 'X';
			MemWrite <= '0';
			ALUSrc <= 'X';
			RegWrite <= '0';
			UBranch <= '1';
			ALUOp <= "XX";
		end if;
	elsif Control = '0' then
		Reg2Loc <= '0';
		CBranch <= '0';
		MemRead <= '0';
		MemtoReg <= '0';
		MemWrite <= '0';
		ALUSrc <= '0';
		RegWrite <= '0';
		UBranch <= '0';
		ALUOp <= "00";
	end if;
	end process;
end BehvCPUC;

