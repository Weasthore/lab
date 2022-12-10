library ieee;
use ieee.std_logic_1164.all;
entity MUX5 is -- Two by one mux with 5 bit inputs/outputs
port(
	in0 : in STD_LOGIC_VECTOR(4 downto 0); -- sel == 0
	in1 : in STD_LOGIC_VECTOR(4 downto 0); -- sel == 1
	sel : in STD_LOGIC; -- selects in0 or in1
	output : out STD_LOGIC_VECTOR(4 downto 0)
);
end MUX5; 

ARCHITECTURE Behavior OF MUX5 IS 
BEGIN
  PROCESS(sel,in0,in1)
  BEGIN

     IF (sel='0') THEN
        output<= in0;
     ELSE
        output <= in1;
     END IF;

  END PROCESS;
END Behavior ;