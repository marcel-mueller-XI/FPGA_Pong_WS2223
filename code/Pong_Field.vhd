------------------------------------------------------
-- Aufgabe: 	Pong										 	 --
-- Datei:	   Pong_Field.vhd					 			 --
-- Autor:   	Jonas Sachwitz & Marco Stütz      	 --
-- Datum:   	09.01.2023                       	 --
------------------------------------------------------

-- ToDo * * * * * * * * * * * * * * * * * * * * * * * *

-- 

-- ToDo * * * * * * * * * * * * * * * * * * * * * * * *

LIBRARY ieee;
USE ieee.std_logic_1164.all;

--! brief Pong_Field
--!
--! Contains the field data

ENTITY Pong_Field IS
	PORT(
		x_value				:  IN    integer;    --! Display X-Pixel from VGA Sig. Gen
		y_value				:  IN    integer;    --! Display Y-Pixel from VGA Sig. Gen
		
		color_field			:	OUT	std_logic;	--! Output for VGA Sig. Gen
		top_left_x        :  OUT   integer;    --! Corner x-point top left
		top_left_y        :  OUT   integer;    --! Corner y-point top left
		top_right_x       :  OUT   integer;    --! Corner x-point top right
		top_right_y       :  OUT   integer;    --! Corner y point top right
		bottom_left_x     :  OUT   integer;    --! Corner x-point bottom left
		bottom_left_y     :  OUT   integer;    --! Corner y-point bottom left
		bottom_right_x    :  OUT   integer;    --! Corner x-point bottom right
		bottom_right_y    :  OUT   integer     --! Corner y-point bottom right
  );
END Pong_Field;

ARCHITECTURE behave OF Pong_Field IS

	signal line_width	       :	integer := 5;		--! linewidth for the lines
	signal screen_width	    :	integer := 640;	--! linewidth for the lines
	signal screen_hight	    :	integer := 480;	--! linewidth for the lines
	signal distance          : integer := 10;
	
	signal top_left_xi       :  integer;    --! Corner x-point top left
	signal top_left_yi       :  integer;    --! Corner y-point top left
	signal top_right_xi      :  integer;    --! Corner x-point top right
	signal top_right_yi      :  integer;    --! Corner y point top right
	signal bottom_left_xi    :  integer;    --! Corner x-point bottom left
	signal bottom_left_yi    :  integer;    --! Corner y-point bottom left
	signal bottom_right_xi   :  integer;    --! Corner x-point bottom right
	signal bottom_right_yi   :  integer;    --! Corner y-point bottom right
	
	signal centerline_min_x  :  integer;    --! Cornerline min value
	signal centerline_max_x  :  integer;    --! Cornerline max value
	signal centerline_y      :  std_logic;    --! Cornerline y flag
	signal centerline_flag   :  std_logic;    --! Cornerline flag 
	
BEGIN

	 -- Coordinates of the corner points
	 top_left_xi    	<= distance;
	 top_left_yi    	<= distance;
	 top_right_xi   	<= screen_width - distance;
	 top_right_yi   	<= distance;
	 bottom_left_xi 	<= distance;
	 bottom_left_yi 	<= screen_hight - distance;
	 bottom_right_xi 	<= screen_width - distance;
	 bottom_right_yi  <= screen_hight - distance;
	 
	 -- Centre line between the players
	 centerline_min_x <= 320 - line_width;
	 centerline_max_x <= 320 + line_width;
	 
	 -- dashed line
	 centerline_y <= '0' WHEN (y_value > 35  AND y_value <= 47)   OR 
									  (y_value > 82  AND y_value <= 94)   OR
									  (y_value > 129  AND y_value <= 141) OR
									  (y_value > 176 AND y_value <= 188)  OR
									  (y_value > 223 AND y_value <= 235)  OR
									  (y_value > 270 AND y_value <= 282)  OR
									  (y_value > 317 AND y_value <= 329)  OR
									  (y_value > 364 AND y_value <= 376)  OR
									  (y_value > 311 AND y_value <= 423)  OR
									  (y_value > 458 AND y_value <= 470)  ELSE
							'1';		  
	 
	 
	 centerline_flag <= '1' WHEN x_value >= centerline_min_x AND x_value <= centerline_max_x AND centerline_y = '1' ELSE
							  '0';
	 -- Value '1' --> White pixel
	 -- Value '0' --> Black pixel
	 color_field <= 	'1' WHEN x_value <= top_left_xi OR x_value >= top_right_xi   OR
	                           y_value <= top_left_yi OR y_value >= bottom_left_yi OR centerline_flag = '1'  ELSE
					      '0';
	
	top_left_x    	<= top_left_xi;
	top_left_y    	<= top_left_yi;
	top_right_x   	<= top_right_xi;
	top_right_y   	<= top_right_yi;
	bottom_left_x 	<= bottom_left_xi;
	bottom_left_y 	<= bottom_left_yi;
	bottom_right_x <= bottom_right_xi;
	bottom_right_y <= bottom_right_yi;
	
END behave;