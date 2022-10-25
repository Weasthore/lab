library ieee;
use ieee.std_logic_1164.all;

entity regi_tb is
end regi_tb;

architecture Behvregi_tb of regi_tb is
	signal RR1, RR2, WR:STD_LOGIC_VECTOR(4 downto 0);
	signal WD, RD1, RD2:STD_LOGIC_VECTOR(63 downto 0);
	signal RegWrite,Clock:STD_LOGIC;
	signal DEBUG_TMP_REGS,DEBUG_SAVED_REGS:STD_LOGIC_VECTOR(64*4 - 1 downto 0);

begin
	instance0 : entity 
		work.registers port map(DEBUG_TMP_REGS =>DEBUG_TMP_REGS,DEBUG_SAVED_REGS=>DEBUG_SAVED_REGS,RR1 => RR1, RR2 => RR2, WR => WR,WD => WD, RD1=>RD1, RD2 => RD2, RegWrite => RegWrite, Clock => Clock);
	
	process
	begin
		Clock <= '0';
		wait for 3 ns;
		Clock <= '1';
		wait for 3 ns;
		if now > 50 ns then
			wait;
		end if;
	end process;	

	process
	begin

		RegWrite <= '1';
		WR <= "01010";  --10
		WD <= "1111111111111111111111111111111100000000000000000000000000000000";
		RR1 <= "01010";
		RR2 <= "01011";
		wait for 10 ns;

		RegWrite <= '1';
		WR <= "10100";  --20
		WD <= "0000000000000000000000000000000011111111111111111111111111111111";
		RR1 <= "10100";
		RR2 <= "01001";
		wait for 10 ns;

		RegWrite <= '1';
		WR <= "10110";  --22
		WD <= "0101010101010101010101010101010101010101010101010101010101010101";
		RR1 <= "10110";
		RR2 <= "10011";
		wait for 10 ns;

		wait;
	end process;
end Behvregi_tb;
