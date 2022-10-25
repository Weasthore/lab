library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX5 is -- Two by one mux with 5 bit inputs/outputs
port(
    in0    : in STD_LOGIC_VECTOR(4 downto 0); -- sel == 0
    in1    : in STD_LOGIC_VECTOR(4 downto 0); -- sel == 1
    sel    : in STD_LOGIC; -- selects in0 or in1
    output : out STD_LOGIC_VECTOR(4 downto 0)
);
end MUX5;

architecture behavioral of MUX5 is
begin

  process(in0,in1,sel) begin
    if(sel = '1') then 
      output(4 downto 0) <= in1(4 downto 0); else
      output(4 downto 0) <= in0(4 downto 0);
    end if;
  end process;
end behavioral; 