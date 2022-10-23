library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CPUControl is
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
end CPUControl;


ARCHITECTURE behavioral of CPUControl is
BEGIN
process(Opcode)
begin

    if( Opcode(7)= '0' ) then --R+addi+subi
      RegDst <= '0'; ALUSrc <= '0'; MemtoReg <= '0'; RegWrite <= '1'; MemRead <= '0'; MemWrite <= '0'; CBranch <= '0'; UBranch <= '0'; ALUOp <= "10"; 
    elsif(Opcode= "11111000010") then --L
      RegDst <= '1'; ALUSrc <= '1'; MemtoReg <= '1'; RegWrite <= '1'; MemRead <= '1'; MemWrite <= '0'; CBranch <= '0'; UBranch <= '0'; ALUOp <= "00"; 
    elsif(Opcode= "11111000000") then --S
      RegDst <= '1'; ALUSrc <= '1'; MemtoReg <= '1'; RegWrite <= '0'; MemRead <= '0'; MemWrite <= '1'; CBranch <= '0'; UBranch <= '0'; ALUOp <= "00"; 
    elsif(Opcode(10 downto 3)= "10110100") then --CB
      RegDst <= '1'; ALUSrc <= '0'; MemtoReg <= '1'; RegWrite <= '0'; MemRead <= '0'; MemWrite <= '0'; CBranch <= '1'; UBranch <= '0'; ALUOp <= "01"; 
	elsif(Opcode(10 downto 5)= "000101") then --B
      RegDst <= '1'; ALUSrc <= '0'; MemtoReg <= '1'; RegWrite <= '0'; MemRead <= '0'; MemWrite <= '0'; CBranch <= '1'; UBranch <= '1'; ALUOp <= "01"; 
	elsif(Opcode= "10010001000" or Opcode= "11010001000") then --I
      RegDst <= '0'; ALUSrc <= '1'; MemtoReg <= '0'; RegWrite <= '1'; MemRead <= '0'; MemWrite <= '0'; CBranch <= '0'; UBranch <= '0'; ALUOp <= "10"; 
   
    end if;
end process;
end behavioral;
