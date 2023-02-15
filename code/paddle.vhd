--Siyabend K.
library IEEE;  
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.PongPack.all;

entity paddle is 
generic(
	xpos : xType := 0;--position on x axis
	PADDLE_SPEED : integer := 1
);

port(
	--inputs
	clk : in std_logic;
	reset : in std_logic;
	a, b : in std_logic; --incremental encoder input

	--outputs (a = oben links, b = unten rechts)
	p_a_x, p_b_x : out xType; --current x-position of paddle for collision module
	p_a_y, p_b_y : out yType; --current y-position of paddle for collision module
	
	--interface for VGA Display Driver
	color_p : out std_logic; --outputs color on given cursor position (1 whend paddle position is on cursor position, 0 else)
	x : in xType; --inputs current position of display cursor
	y : in yType; --inputs current position of display cursor
	
	En_test : in std_logic;
	Up_nDown_test : in std_logic
	);

end entity paddle;

architecture behave of paddle is

	signal pos_x : xType;	--! pos_a defines upper left corner of paddle, pos_x defines x-position of this point
	signal pos_y : yType;	--! pos_a defines upper left corner of paddle, pos_y defines y-position of this point
	signal x_display : xType;	--! added intern singal to enhance readability of signal
	signal y_display : yType;	--! added intern singal to enhance readability of signal
	signal Up_nDown : std_logic; 
	signal En : std_logic;
	

begin
	x_display <= x;
	y_display <= y;
	pos_x <= xpos;
	En <= En_test;
	Up_nDown <= Up_nDown_test;


	color_p <= '1' when pos_x <= x_display and x_display <= (pos_x + PADDLE_WIDTH) 
					and pos_y <= y_display and y_display <= (pos_y + PADDLE_HEIGHT) else '0';				
				
	p_a_y <= pos_y;
	p_a_x <= pos_x;                   
	p_b_y <= (pos_y + PADDLE_HEIGHT);
	p_b_x <= (pos_x + PADDLE_WIDTH);
	
	-- Paddle Movement Process
    paddle_movement : process(clk, reset)
	 variable temp_pos_y : integer range -1024 to 1023;
    begin
		if (reset='1') then
			pos_y <= (DISPLAY_HEIGHT/2 - PADDLE_HEIGHT/2);
        elsif rising_edge(clk) then
   -- Positioning of the paddle
            if Up_nDown = '1' and En = '1' then
                temp_pos_y := (pos_y - PADDLE_SPEED);
            elsif Up_nDown = '0' and En = '1' then
                temp_pos_y := (pos_y + PADDLE_SPEED);
            end if;

   -- Paddle shouldn't cross display area
            if temp_pos_y < 0 then
                temp_pos_y := 0;
            elsif temp_pos_y > (DISPLAY_HEIGHT - PADDLE_HEIGHT) then
                temp_pos_y := (DISPLAY_HEIGHT - PADDLE_HEIGHT);
            end if;
				pos_y <= temp_pos_y;
        end if;
    end process;
	 

	 
inc_enc: entity work.IncrementalEncoder(behave)
port Map (
	Reset => reset,
	A => a,
	B => b,
	Clk => clk,
	En => open,
	Up_nDown => open
);

end architecture behave;

