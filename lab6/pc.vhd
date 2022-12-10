library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PC is -- 64-bit rising-edge triggered register with write-enable and Asynchronous reset
-- For more information on what the PC does, see page 251 in the textbook
port(
	clk : in STD_LOGIC; -- Propogate AddressIn to AddressOut on rising edge of clock
	PCwrite : in STD_LOGIC; -- Only write if 
	rst : in STD_LOGIC; -- Asynchronous reset! Sets AddressOut to 0x0
	AddressIn : in STD_LOGIC_VECTOR(63 downto 0); -- Next PC address
	AddressOut : out STD_LOGIC_VECTOR(63 downto 0) -- Current PC address
);
end PC;

architecture PC_example of PC is
begin
	process(clk,rst,PCwrite)
begin
	if rst='1' then 
		AddressOut <= "0000000000000000000000000000000000000000000000000000000000000000";
	elsif (rising_edge(clk))  and PCwrite ='1'  then
		
			AddressOut <= AddressIn;
		
	end if;
end process;
end PC_example;