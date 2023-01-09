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
	signal end_match            : std_logic := '0';
	signal reset_score          : std_logic := '0';
	signal start_ball           : std_logic := '0';

begin

DUT: entity work.Control
port map(
	clk => clk_tb,
	reset => reset_tb,
    
    button_start => button_start,
	button_resetMatch => button_resetMatch,
	ball_outOfField => ball_outOfField,
	end_match => end_match,

	reset_score => reset_score,
	start_ball => start_ball
    );

-- tester:


end architecture sim;