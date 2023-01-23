--------------------------------------------------------------------------
-- @task:	 	Pong										 	 							--
-- @file:	   ball.vhd					 			 		 							--
-- @brief:		ball logic of the game pong			 							--
-- @details:	incremental increase in ball speed, collision detection  --
--					and feedback, same angular values for in and out			--
-- @autor:   	Andreas Kanz & Hannes Kollmar      								--
-- @date:   	20.01.2023                       	 							--
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--	Tasks left:
--		- checking of right calculation on the ballspeed on the display
--		- review code & testing
--------------------------------------------------------------------------

-- included libraries

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


library work;
use work.PongPack.all; --! Using selfmade library for standardised shared variables

---------------------------------------------------------------
--    SUBTYPE xType IS integer RANGE 0 TO 1023;
--    SUBTYPE yType IS integer RANGE 0 TO 1023;
--
--    constant MAIN_CLOCK     : integer := 25175000; --! in Hz = 39,722 ns
--    constant COLOR_DEPTH    : integer := 4;
--    constant DISPLAY_WIDTH  : integer := 640;
--    constant DISPLAY_HEIGHT : integer := 480;
--    constant BALL_DIAMETER  : integer := 20;
--    constant PADDLE_WIDTH   : integer := 20;
--    constant PADDLE_HEIGHT  : integer := 60;
--    constant MAX_SCORE      : integer := 5;
---------------------------------------------------------------
-- Berechnung Ballspeed on display
-- Clock = 25 MHz / In Zeit von 5s / Bildschirmbreite von 640 Pixel bewegen 
-- 25_000_000 Hz * 5 s / 640 = 195312,5  
-- je 195312,5 rising_edge Flanken einen Pixel bewegen
---------------------------------------------------------------

-- Entity for the pong ball
entity ball is
    port(
			-- FOR Functionality IN:
			-- IN:
				clk 				:	in std_logic;		--! 25,175 Mhz signal clock
				-- reset				:	in std_logic;		--! asynchron reset signal
				
			-- VGA IN and OUT:
			-- IN:
				x_Value			: in xType;		--! Display X-Value Pixle from VGA Signal
				Y_Value			: in yType; 		--! Display Y-Value Pixel from VGA Signal
			-- OUT:
				pixle_Colour	: out std_logic;	--! 0 -> black, 1 -> white colour for VGA Signal

				
			-- Paddle IN:								--! p1 -> paddle links, p2 -> paddle rechts | A -> oben/links, B -> unten/rechts
			-- IN:
				p1B_x : 	in xType;					--! paddle left, X-coordinates facing inside of the field
				p1A_y : 	in yType;					--! paddle left, Y-coordinates top pixle of the paddle									
				p1B_y	:	in yType;					--! paddle left, Y-coordinates bottom pixle of the paddle
				
				p2A_x : 	in xType;					--! paddle right, X-coordinates facing inside of the field
				p2A_y : 	in yType;					--! paddle right, Y-coordinates top pixle of the paddle										
				p2B_y	:	in yType;					--! paddle right, Y-coordinates bottom pixle of the paddle

				
			-- Field IN:
			-- IN:
				-- top_left_x        :  in   	xType	:= 15;    --! Corner x-point top left
				-- top_left_y        :  in   	yType	:= 15;    --! Corner y-point top left
				-- top_right_x       :  in   	xType;    --! Corner x-point top right
				-- top_right_y       :  in   	yType;    --! Corner y point top right
				-- bottom_left_x     :  in   	xType;    --! Corner x-point bottom left
				-- bottom_left_y     :  in 	yType;    --! Corner y-point bottom left
				bottom_right_x    :  in	   xType;    --! Corner x-point bottom right
				bottom_right_y    :  in		yType;    --! Corner y-point bottom right				
			
				
			-- Sound, score and control OUT and IN: 
			-- IN:
				start_ball			: 	in		std_logic;	--! if true start moving the ball, else reset all
			-- OUT:
				paddle_bounce		:	out	std_logic; 	--! true if the paddle was hit
				field_bounce		:	out	std_logic; 	--! true if the edge was hit
				ball_outOfField	:	out	std_logic; 	--! true if the goal was hit
				out_left				:	out	std_logic; 	--! true if the ball hits left goal
				out_right			:	out	std_logic 	--! true if the ball hits right goal
    );
end entity ball;

Architecture behave of ball is

		type direction_x is (LEFT, RIGHT);
		type direction_y is (UP, DOWN);
		
		-- signal ball_diameter_int							: BALL_DIAMETER; 					--! diameter of the ball
		signal ball_diameter_int							: integer := 20; 					--! diameter of the ball
		signal ball_x_movement_int						 	: direction_x;						--! stores the direction of the ball
		signal ball_y_movement_int							: direction_y;						--! stores the direction of the ball
		signal ball_x_position_int							: xType;								--! x-position of the ball
		signal ball_y_position_int							: yType;								--! y-position of the ball
		signal ball_speed_int								: integer range 0 to 195313;	--! temp_cpunt_up * rising_edge(clk) -> move ball 1 pixle
		signal temp_count_up_int							: integer range 0 to 262143;  --! used to count against ball_speed with clk (2^(18) - 1)
		signal paddle_bounce_int							: std_logic;
		signal field_bounce_int								: std_logic;
		signal ball_outOfField_int							: std_logic;
		signal out_left_int									: std_logic;
		signal out_right_int									: std_logic;
		
		-- to save IO input pads in the designe
		signal top_left_x           						: integer	:= 15;    --! Corner x-point top left
		signal top_left_y        					   	: integer	:= 15;    --! Corner y-point top left
		
	
begin
	
	ball_diameter_int <= BALL_DIAMETER;
	top_left_x <= 15;
	top_left_y <= 15;
	paddle_bounce 		<= paddle_bounce_int;
	field_bounce 		<= field_bounce_int;
	ball_outOfField 	<= ball_OutOfField_int;
	out_left 			<= out_left_int;
	out_right 			<= out_right_int;
	
	-- Value '1' = white pixle, '0' = black pixle
	-- Giving out the ball in for VGA
	pixle_Colour 		<= '1' 	when 	x_Value <= (ball_x_position_int + ball_diameter_int) and 
												x_Value >= (ball_x_position_int - ball_diameter_int) and 
												y_Value <= (ball_y_position_int + ball_diameter_int) and 
												y_Value >= (ball_y_position_int - ball_diameter_int) else 
							   '0';


	ball_logic : process (clk)
	begin
	
		if rising_edge(clk) then
		
			if (start_ball = '1') then 
				temp_count_up_int <= temp_count_up_int + 1;
				
				if (temp_count_up_int >= ball_speed_int) then 
					--! update the ball position
					if (ball_x_movement_int = RIGHT) then
						 ball_x_position_int <= ball_x_position_int + 1;
					else
						 ball_x_position_int <= ball_x_position_int - 1;
					end if; -- update ball movement right/left

					if (ball_y_movement_int = UP) then
						 ball_y_position_int <= ball_y_position_int - 1;
					else
						 ball_y_position_int <= ball_y_position_int + 1;
					end if; -- update ball movement up/down
					temp_count_up_int <= 0;
				end if; -- end if (temp_count_up_int >= ball_speed)

				
				-- changes y direction and plays the field_bounce sound once
				if (ball_y_movement_int = UP and (ball_y_position_int - ball_diameter_int - 1) = top_left_y) then
					ball_y_movement_int <= DOWN;
					field_bounce_int <= '1';	
				elsif (ball_y_movement_int = DOWN and (ball_y_position_int + ball_diameter_int + 1) = (DISPLAY_HEIGHT + bottom_right_y)) then
					ball_y_movement_int <= UP;
					field_bounce_int <= '1';
				else
					 field_bounce_int <= '0';
				end if; -- end if  ball direction_y and sound field_bounce

				-- changes x-direction and plays the (paddle bounce or ball_outOfField) sound once
				if (ball_x_movement_int = LEFT and (ball_x_position_int - ball_diameter_int - 1) <= p1B_x) then
					if (((ball_y_position_int - ball_diameter_int) >= p1A_y) and ((ball_y_position_int + ball_diameter_int) <= p1B_y)) then
						ball_x_movement_int <= RIGHT;
						paddle_bounce_int <= '1';
					end if; -- paddle bounce left
					
					if ((ball_x_position_int - ball_diameter_int - 1) = top_left_x) then
						ball_x_movement_int <= RIGHT;
						ball_outOfField_int <= '1';
						out_left_int <= '1';
					end if; -- into the left goal
					
				elsif (ball_x_movement_int = RIGHT and (ball_x_position_int + ball_diameter_int + 1) >= p2A_x) then
					if (((ball_y_position_int - ball_diameter_int) >= p2A_y) and ((ball_y_position_int + ball_diameter_int) <= p2B_y)) then
						ball_x_movement_int <= LEFT;
						paddle_bounce_int <= '1';
					end if; -- paddle bounce right
					if ((ball_x_position_int + ball_diameter_int + 1) = bottom_right_x) then
						ball_x_movement_int <= LEFT;
						ball_outOfField_int <= '1';
						out_right_int <= '1';
					end if; -- into the right goal

				else
					paddle_bounce_int <= '0';
					ball_outOfField_int <= '0';
					out_left_int <= '0';
					out_right_int <= '0';
				end if; -- end change x-direction and plays the sound once
			
			else
				ball_x_movement_int <= RIGHT;
				ball_y_movement_int <= UP;
				ball_x_position_int <= (DISPLAY_WIDTH / 2);
				ball_y_position_int <= (DISPLAY_HEIGHT / 2);
			
			end if; -- end if start_ball = '1'
				
		end if; -- end if rising_edge(clk)

	end process ball_logic;

end behave;