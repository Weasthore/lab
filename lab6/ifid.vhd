library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;  

entity IFID is
port(
	clk	 : in  STD_LOGIC;
	IFIDWrite : in  STD_LOGIC; -- Only write if '1'
        rst      : in  STD_LOGIC;
	if_flush  : in std_logic;  
	ifid_pcin: in  STD_LOGIC_VECTOR(63 downto 0);
	ifid_imin: in  STD_LOGIC_VECTOR(31 downto 0);
	ifid_pcout: out  STD_LOGIC_VECTOR(63 downto 0);
	ifid_imout: out  STD_LOGIC_VECTOR(31 downto 0)
);
end IFID;

architecture behv_ifid of IFID is

begin 
	process(clk, rst, IFIDWrite)
	begin
		if rst = '1' then
			ifid_pcout <= X"0000000000000000";
			ifid_imout <= X"00000000";
		elsif rising_edge(clk) then
			if if_flush = '1' then
				ifid_pcout <= X"0000000000000000";
				ifid_imout <= X"00000000";
			elsif IFIDWrite = '1' then
				ifid_pcout <= ifid_pcin;
				ifid_imout <= ifid_imin;
			end if;
		end if;
	end process;
end behv_ifid;