-- paddle_tb
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.PongPack.all;

entity paddle_tb is
end entity paddle_tb;

architecture sim of paddle_tb is
	signal clk_tb	: std_logic := '0';
	signal reset_tb : std_logic := '0';

   signal a : std_logic := '0';
	signal b : std_logic := '0'; --incremental encoder input

	--outputs (a = oben links, b = unten rechts)
	signal p_a_x : xType := 0;
	signal p_b_x : xType := 0; --current x-position of paddle for collision module
	signal p_a_y : yType := 0;
	signal p_b_y : yType := 0; --current y-position of paddle for collision module
	
	--interface for VGA Display Driver
	signal color_p : std_logic := '0'; --outputs color on given cursor position (1 whend paddle position is on cursor position, 0 else)
	signal x : xType := 0; --inputs current position of display cursor
	signal y : yType := 0; --inputs current position of display cursor

	-- tester
	signal En_test : std_logic := '0';
	signal Up_nDown_test : std_logic := '0';

   constant PERIOD : time := 40 ns;		-- 25,175Mhz
   constant offset : time := 50 ns;

begin

DUT: entity work.paddle
generic map(
	xpos => 20,
	PADDLE_SPEED => 1 
	)
port map(
	clk => clk_tb,
	reset => reset_tb,

   a => a,
	b => b,

	--outputs (a = oben links, b = unten rechts)
	p_a_x => p_a_x,
	p_b_x => p_b_x,
	p_a_y => p_a_y,
	p_b_y => p_b_y,
	
	--interface for VGA Display Driver
	color_p => color_p,
	x => x,
	y => y,
	
	En_test => En_test,
	Up_nDown_test => Up_nDown_test
    );

-- tester:

	clk_tb <= not(clk_tb) after PERIOD/2;
	
  	reset_tb <= '0', '1' after 10 ns, '0' after 30 ns;
	

end architecture sim;