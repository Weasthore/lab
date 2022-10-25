library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IMEM_tb is
end IMEM_tb;

architecture BehvIMEM_tb of IMEM_tb is

    component IMEM
        port (Address  : in std_logic_vector (63 downto 0);
              ReadData : out std_logic_vector (31 downto 0));
    end component;

    signal Address  : std_logic_vector (63 downto 0);
    signal ReadData : std_logic_vector (31 downto 0);

begin

    uut : IMEM
    port map (Address  => Address,
              ReadData => ReadData);

    stim : process
    begin
	
	Address <= "0000000000000000000000000000000000000000000000000000000000001011";
	wait for 50 ns;

	Address <= "0000000000000000000000000000000000000000000000000000000000010000";
	wait for 50 ns;
        wait;
    end process;

end BehvIMEM_tb;


