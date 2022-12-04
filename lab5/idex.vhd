library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;  

entity IDEX is 
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

	  IDEX_RRn 	   : in  std_logic_vector(4 downto 0);
	  IDEX_RRm 	   : in  std_logic_vector(4 downto 0);
	  IDEX_RRd	   : in  std_logic_vector(4 downto 0);
          IDEX_STINS_in    : in  std_logic_vector(10 downto 0);
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
          IDEX_instr5       : out std_logic_vector(4 downto 0);
	  IDEX_Rn 	   : out  std_logic_vector(4 downto 0);
	  IDEX_Rm 	   : out  std_logic_vector(4 downto 0);
	  IDEX_Rd	   : out  std_logic_vector(4 downto 0);
	  IDEX_STINS       : out  std_logic_vector(10 downto 0)
);   
end IDEX;

architecture behav_IDEX of IDEX is

begin
process(clk)
        begin
            if rising_edge(clk) then
		IDEX_Reg2Loc <= IDEX_Reg2Loc_in;
                IDEX_CBranch <= IDEX_CBranch_in;
                IDEX_MemRead <= IDEX_MemRead_in;
                IDEX_MemtoReg <= IDEX_MemtoReg_in;
                IDEX_MemWrite <= IDEX_MemWrite_in;
                IDEX_ALUSrc <= IDEX_ALUSrc_in;
                IDEX_RegWrite <= IDEX_RegWrite_in;
                IDEX_UBranch <= IDEX_UBranch_in;
                IDEX_ALUOp <= IDEX_ALUOp_in;
                IDEX_RD1 <= IDEX_RD1_in;
                IDEX_RD2 <= IDEX_RD2_in;
                IDEX_pc <= IDEX_pc_in;
                IDEX_signextend <= IDEX_signextend_in;
                IDEX_instr11 <= IDEX_instr11_in;
                IDEX_instr5 <= IDEX_instr5_in;     
	 	IDEX_Rn <= IDEX_RRn;
	        IDEX_Rm <= IDEX_RRm;
		IDEX_Rd <= IDEX_RRd;
		IDEX_STINS <=  IDEX_STINS_in;
            end if;
        end process;
end behav_IDEX;
