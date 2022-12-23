-- Control

library ieee;
use ieee.std_logic_1164.all;

entity Control is
port(
	button_start : in std_logic;
	button_resetGame : in std_logic;
	ball_out_ofField : in std_logic;
	
	reset_score : out std_logic;
	start_ball : out std_logic;
);
end entity Control;