library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;  

entity IdEx is 
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
end IdEx;

architecture behavioral of IdEx is

begin
process(clk)
        begin
            if( clk'event and clk = '1') then
                IdEx_RegDst <= IdEx_RegDst_in;
                IdEx_CBranch <= IdEx_CBranch_in;
                IdEx_MemRead <= IdEx_MemRead_in;
                IdEx_MemtoReg <= IdEx_MemtoReg_in;
                IdEx_MemWrite <= IdEx_MemWrite_in;
                IdEx_ALUSrc <= IdEx_ALUSrc_in;
                IdEx_RegWrite <= IdEx_RegWrite_in;
                IdEx_UBranch <= IdEx_UBranch_in;
                IdEx_ALUOp <= IdEx_ALUOp_in;
                IdEx_RD1 <= IdEx_RD1_in;
                IdEx_RD2 <= IdEx_RD2_in;
                IdEx_pc <= IdEx_pc_in;
                IdEx_signextend <= IdEx_signextend_in;
                IdEx_instr11 <= IdEx_instr11_in;
                IdEx_instr5 <= IdEx_instr5_in;                        
            end if;
        end process;
end behavioral;