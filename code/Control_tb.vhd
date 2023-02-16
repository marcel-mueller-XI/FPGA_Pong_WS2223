-- Control_tb
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Control_tb is
end entity Control_tb;

architecture sim of Control_tb is
	signal clk_tb	: std_logic := '0';
	signal reset_tb : std_logic := '0';

    signal button_start         : std_logic := '0';
	signal button_resetMatch    : std_logic := '0';
	signal ball_outOfField      : std_logic := '0';
	signal score_max            : std_logic := '0';
	signal reset_score          : std_logic := '0';
	signal start_ball           : std_logic := '0';

   constant PERIOD : time := 40 ns;		-- 25,175Mhz
   constant offset : time := 50 ns;

begin

DUT: entity work.Control
port map(
	clk => clk_tb,
	reset => reset_tb,

    button_start => button_start,
	button_resetMatch => button_resetMatch,
	ball_outOfField => ball_outOfField,
	score_max => score_max,

	reset_score => reset_score,
	start_ball => start_ball
    );

-- tester:

	clk_tb <= not(clk_tb) after PERIOD/2;
	
   button_start <= '0', '1' after 110 ns, '0' after 150 ns, 								'1' after 410 ns, '0' after 430 ns, '1' after 490 ns, '0' after 510 ns;
   button_resetMatch <= '0', 					'1' after 190 ns, '0' after 230 ns, 			'1' after 490 ns, '0' after 510 ns,							'1' after 530 ns, '0' after 550 ns, '1' after 610 ns, '0' after 630 ns, '1' after 690 ns, '0' after 800 ns, '1' after 810 ns, '0' after 830 ns, '1' after 890 ns, '0' after 910 ns;
   ball_outOfField <= '0', 								'1' after 290 ns, '0' after 330 ns,						'1' after 450 ns, '0' after 470 ns;
   score_max <= '0',  								'1' after 250 ns, '0' after 270 ns, 						'1' after 450 ns, '0' after 510 ns;
	

end architecture sim;