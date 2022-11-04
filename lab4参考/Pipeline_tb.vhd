library ieee;  
use ieee.std_logic_1164.all;  
use ieee.std_logic_unsigned.all;  

entity Pipeline_tb is   
end Pipeline_tb; 

architecture Pipeline_tb of Pipeline_tb is  
component PipelinedCPU0 is
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
end component;
  
  signal clk              :std_logic;
  signal rst              :std_logic:='1';
  constant clk_period :time :=200 ns;    
    
  begin  
    uut: PipelinedCPU0 port map  
    (  
      clk=>clk,
      rst=>rst
      );  
      
  time_gen_proc:process  
    begin      
    wait for clk_period/2;  
    clk<='1';    
    wait for clk_period/2;  
    clk<='0';  
  end process; 
  
  stim_proc:process
  begin      
  rst<='1';
  wait for 300ns;
  
  rst<='0'; 
  wait;

  end process;  
end;