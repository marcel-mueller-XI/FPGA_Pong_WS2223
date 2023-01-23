library ieee;
use ieee.std_logic_1164.all;

library work;
use work.PongPack.all;

entity ball_tb is
end entity ball_tb;

architecture sim of ball_tb is
	signal clkt : std_logic;
	signal x_Valuet : xType;
	signal Y_Valuet : yType;
	signal p1B_xt : 	 xType;					--! paddle left, X-coordinates facing inside of the field
	signal p1A_yt : 	 yType;					--! paddle left, Y-coordinates top pixle of the paddle									
	signal p1B_yt :	 yType;					--! paddle left, Y-coordinates bottom pixle of the paddle
	
	signal p2A_xt : 	 xType;					--! paddle right, X-coordinates facing inside of the field
	signal p2A_yt : 	 yType;					--! paddle right, Y-coordinates top pixle of the paddle										
	signal p2B_yt	:	 yType;					--! paddle right, Y-coordinates bottom pixle of the paddle
	signal bottom_right_xt    : xType;    --! Corner x-point bottom right
	signal bottom_right_yt    : yType;    --! Corner y-point bottom right			
	
	signal start_ballt			: std_logic;	--! if true start moving the ball, else reset all
begin

dut: entity work.ball
port map(
	clk => clkt,
	x_Value => x_Valuet,
	y_Value => y_Valuet,
	
	p1B_x => p1B_xt,
	p1A_y => p1A_yt,
	p1B_y => p1B_yt,
	
	p2A_x => p2A_xt,
	p2A_y => p2A_yt,
	p2B_y => p2B_yt,
	
	bottom_right_x => bottom_right_xt,
	bottom_right_y => bottom_right_yt,
	start_ball => start_ballt
);

tester: entity work.ball_tester(sim)
port map(
	clk => clkt,
	x_Value => x_Valuet,
	y_Value => y_Valuet,
	
	p1B_x => p1B_xt,
	p1A_y => p1A_yt,
	p1B_y => p1B_yt,
	
	p2A_x => p2A_xt,
	p2A_y => p2A_yt,
	p2B_y => p2B_yt,
	
	bottom_right_x => bottom_right_xt,
	bottom_right_y => bottom_right_yt,
	start_ball => start_ballt
);

end architecture sim;