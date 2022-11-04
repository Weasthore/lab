library ieee;  
use ieee.std_logic_1164.all;  
use ieee.std_logic_unsigned.all;  

entity cpu_tb is   
end cpu_tb; 

architecture cpu_tb of cpu_tb is  
  component SingleCycleCPU
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
  end component;  
  
  signal clk :std_logic;
  signal rst :std_logic;    
  constant clk_period: time := 200 ns;
  begin  
    uut: SingleCycleCPU port map  
    (  
      clk=>clk,
      rst=>rst
      );  
      
  clk_process : process
  begin
	clk <= '1';
	wait for clk_period/2;
	clk <= '0';
	wait for clk_period/2;
	if now > 2200 ns then
		wait;
	end if;
  end process;
  
  stim_process : process
  begin      
 	rst<='1';
  	wait for 75 ns;
  	rst<='0'; 
  	wait for 2200 ns;
	wait;

  end process;  
end;
