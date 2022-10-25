library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL; 

entity dmem_tb is
end dmem_tb;

architecture Behvdmem_tb of dmem_tb is
    signal MemRead, MemWrite: std_logic;
    signal WriteData, Address, ReadData: std_logic_vector(63 downto 0);
    signal Clock : std_logic := '0';
    signal DEBUG_MEM_CONTENTS : STD_LOGIC_VECTOR(64*4 - 1 downto 0);

begin
    instance0 : entity 
	work.DMEM port map(MemRead => MemRead, MemWrite => MemWrite, WriteData => WriteData, Address => Address,ReadData => ReadData, Clock => Clock, DEBUG_MEM_CONTENTS => DEBUG_MEM_CONTENTS);

    process
	begin
	    wait for 3 ns;
            Clock <= '1';
            wait for 3 ns;
            Clock <= '0';
	    if now > 50 ns then
		wait;
	    end if;
    end process;

    process
    begin    

        MemWrite <= '1';
      	MemRead <= '0';
        WriteData <= "1111111111111111111111111111111100000000000000000000000000000000";
      	Address <= "0000000000000000000000000000000000000000000000000000000000000010"; --2
	wait for 10 ns;
        
	MemWrite <= '1';
      	MemRead <= '0';
        WriteData <= "0000000000000000000000000000000011111111111111111111111111111111";
      	Address <= "0000000000000000000000000000000000000000000000000000000000000111"; --7
	wait for 10 ns;

        MemWrite <= '0';
      	MemRead <= '1';
      	Address <= "0000000000000000000000000000000000000000000000000000000000000010";--2
	wait for 10 ns;  
        assert (ReadData = "1111111111111111111111111111111100000000000000000000000000000000")
	report "Error!!" severity error;

        MemWrite <= '0';
      	MemRead <= '1';
      	Address <= "0000000000000000000000000000000000000000000000000000000000000111";--7
	wait for 10 ns;  
        assert (ReadData = "0000000000000000000000000000000011111111111111111111111111111111")
	report "Error!!" severity error;
	wait;


   end process;
end Behvdmem_tb;
