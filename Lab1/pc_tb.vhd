library ieee;
use ieee.std_logic_1164.all;
entity PC_tb is
end PC_tb;

architecture PV_behv of PC_tb is

	component PC
	port(
     		clk          : in  STD_LOGIC; -- Propogate AddressIn to AddressOut on rising edge of clock
    		write_enable : in  STD_LOGIC; -- Only write if '1'
    		rst          : in  STD_LOGIC; -- Asynchronous reset! Sets AddressOut to 0x0
     		AddressIn    : in  STD_LOGIC_VECTOR(63 downto 0); -- Next PC address
     		AddressOut   : out STD_LOGIC_VECTOR(63 downto 0) -- Current PC address
	);
	end component; 

	signal clk, rst, write_enable : STD_LOGIC := '0';
	signal AddressIn : STD_LOGIC_VECTOR(63 downto 0) :=(others => '0');
	signal AddressOut : STD_LOGIC_VECTOR(63 downto 0);
	constant clk_period : time := 10 ns;
begin
	uut: PC PORT MAP(clk => clk, rst => rst, write_enable => write_enable, AddressIn => AddressIn, AddressOut => AddressOut);

	clk_process : process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
		if now > 100 ns then
			wait;
		end if;
	end process;

	stim_process : process
	begin 
		AddressIn <= "0000000000000000000000000000000000000000000000000000000000000101";
		rst <= '1';
		write_enable <= '0';
		wait for 20 ns;
		
		AddressIn <= "0000000000000000000000000000000000000000000000000000000000000111";
		rst <= '0';
		write_enable <= '1';
		wait for 20 ns;

		AddressIn <= "0000000000000000000000000000000000000000000000000000000000010001";
		rst <= '0';
		write_enable <= '1';
		wait for 20 ns;

		AddressIn <= "0000000000000000000000000000000000000000000000000000000001111000";
		rst <= '0';
		write_enable <= '0';
		wait for 20 ns;

		AddressIn <= "0000000000000000000000000000000000000000000000000000000000000110";
		rst <= '1';
		write_enable <= '1';
		wait for 20 ns;
		wait;
	end process;
end;








