library ieee;
use ieee.std_logic_1164.all;

library work;
use work.PongPack.all;

entity ball_tester is
port (
	signal clk : out std_logic;
	-- VGA IN and OUT:
-- IN:
	signal x_Value			: out xType;		--! Display X-Value Pixle from VGA Signal
	signal Y_Value			: out yType; 		--! Display Y-Value Pixel from VGA Signal
-- Paddle IN:								--! p1 -> paddle links, p2 -> paddle rechts | A -> oben/links, B -> unten/rechts
-- IN:
	signal p1B_x : 	out xType;					--! paddle left, X-coordinates facing inside of the field
	signal p1A_y : 	out yType;					--! paddle left, Y-coordinates top pixle of the paddle									
	signal p1B_y	:	out yType;					--! paddle left, Y-coordinates bottom pixle of the paddle
	
	signal p2A_x : 	out xType;					--! paddle right, X-coordinates facing inside of the field
	signal p2A_y : 	out yType;					--! paddle right, Y-coordinates top pixle of the paddle										
	signal p2B_y	:	out yType;					--! paddle right, Y-coordinates bottom pixle of the paddle
	
	signal bottom_right_x    :  out	   xType;    --! Corner x-point bottom right
	signal bottom_right_y    :  out		yType;    --! Corner y-point bottom right				
-- Sound, score and control OUT and IN: 
-- IN:
	signal start_ball			: 	out		std_logic	--! if true start moving the ball, else reset all
);
end entity ball_tester;

architecture sim of ball_tester is
constant clock_period : time := 10 ps;
constant nxt_period : time := 20 ps;
begin

clock_process: process
begin 
	clk <= '1';
	wait for clock_period/2;
	clk <= '0';
	wait for clock_period/2;
end process;

start_ball <= '0', '1' after nxt_period;
--next_process: process
--begin
--	start_ball <= '0';
--	wait for nxt_period;
--	start_ball <= '1';
--	wait for nxt_period;
--end process;
end architecture sim;