library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;  

entity ExMem is 
port(
 	  clk               :  in STD_LOGIC;
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
          ExMem_RD2_in      : in std_logic_vector(63 downto 0);  
          ExMem_instr5_in   : in std_logic_vector(4 downto 0);   
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
          
end ExMem;

architecture behav_ExMem of ExMem is

begin
process(clk)
        begin
            if rising_edge(clk) then
		ExMem_Reg2Loc <=  ExMem_Reg2Loc_in; 
                ExMem_CBranch <= ExMem_CBranch_in;
                ExMem_MemRead <= ExMem_MemRead_in;
                ExMem_MemtoReg <= ExMem_MemtoReg_in;
                ExMem_MemWrite <= ExMem_MemWrite_in;
                ExMem_RegWrite <= ExMem_RegWrite_in;
                ExMem_UBranch <= ExMem_UBranch_in;
                ExMem_Addout <= ExMem_Addin;
                ExMem_Zero <= ExMem_Zero_in;
                ExMem_Aluresult <= ExMem_Aluresult_in;
                ExMem_RD2 <= ExMem_RD2_in;
                ExMem_instr5 <= ExMem_instr5_in;
            end if;
        end process;
end;
