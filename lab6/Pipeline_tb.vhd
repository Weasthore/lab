library ieee;  
use ieee.std_logic_1164.all;  
use ieee.std_logic_signed.all;  

entity Pipeline_tb is   
end Pipeline_tb; 

architecture behv_pip of Pipeline_tb is  
component PipelinedCPU1 is
port(
     clk : in STD_LOGIC;
     rst : in STD_LOGIC;
     --Probe ports used for testing
     -- Forwarding control signals
     DEBUG_FORWARDA : out std_logic_vector(1 downto 0);
     DEBUG_FORWARDB : out std_logic_vector(1 downto 0);
     --The current address (AddressOut from the PC)
     DEBUG_PC : out STD_LOGIC_VECTOR(63 downto 0);
     --Value of PC.write_enable
     DEBUG_PC_WRITE_ENABLE : out STD_LOGIC;
     --The current instruction (Instruction output of IMEM)
     DEBUG_INSTRUCTION : out STD_LOGIC_VECTOR(31 downto 0);
     --DEBUG ports from other components
     DEBUG_TMP_REGS     : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
     DEBUG_SAVED_REGS   : out STD_LOGIC_VECTOR(64*4 - 1 downto 0);
     DEBUG_MEM_CONTENTS : out STD_LOGIC_VECTOR(64*4 - 1 downto 0)
);
end component;
  
  signal clk :STD_LOGIC;
  signal rst :STD_LOGIC;
  signal DEBUG_FORWARDA: std_logic_vector(1 downto 0);
  signal DEBUG_FORWARDB: std_logic_vector(1 downto 0);
  signal DEBUG_PC_WRITE_ENABLE: STD_LOGIC;
  signal DEBUG_PC : STD_LOGIC_VECTOR(63 downto 0);
  signal DEBUG_INSTRUCTION :  STD_LOGIC_VECTOR(31 downto 0);
  signal DEBUG_TMP_REGS :  STD_LOGIC_VECTOR(64*4 - 1 downto 0);
  signal DEBUG_SAVED_REGS :  STD_LOGIC_VECTOR(64*4 - 1 downto 0);
  signal DEBUG_MEM_CONTENTS : STD_LOGIC_VECTOR(64*4 - 1 downto 0);    
  constant clk_period: time := 200 ns;    
    
  begin  
    uut: PipelinedCPU1 port map  
    (  
      	DEBUG_PC => DEBUG_PC,
      	DEBUG_INSTRUCTION  => DEBUG_INSTRUCTION,
     	DEBUG_TMP_REGS     => DEBUG_TMP_REGS,
     	DEBUG_SAVED_REGS   => DEBUG_SAVED_REGS,
     	DEBUG_MEM_CONTENTS => DEBUG_MEM_CONTENTS,
	DEBUG_FORWARDA => DEBUG_FORWARDA,
	DEBUG_FORWARDB => DEBUG_FORWARDB,
	DEBUG_PC_WRITE_ENABLE => DEBUG_PC_WRITE_ENABLE,
	clk => clk,
      	rst => rst
      );  
      
  clk_process : process  
  begin      
	
	clk <= '1';
	wait for clk_period/2;
	clk <= '0';
	wait for clk_period/2;
	if now > 3200 ns then
		wait;
	end if;
  end process; 
  
  stim_proc:process
  begin      
  	rst <= '1';
 	wait for 80 ns;
  	rst<='0'; 
	wait for 3200 ns;
 	wait;

  end process;  
end;