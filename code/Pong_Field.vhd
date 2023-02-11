------------------------------------------------------
-- Aufgabe: 	Pong										 	 --
-- Datei:	   Pong_Field.vhd					 			 --
-- Autor:   	Jonas Sachwitz & Marco Stütz      	 --
-- Datum:   	18.01.2023                       	 --
------------------------------------------------------

-- ToDo * * * * * * * * * * * * * * * * * * * * * * * *

-- 

-- ToDo * * * * * * * * * * * * * * * * * * * * * * * *

LIBRARY ieee;
USE ieee.std_logic_1164.all;
library work;
use work.PongPack.all;  -- own project 

--! brief Pong_Field
--!
--! The Field module serves as the game environment and background image, it is responsible for the display and organization of the game area.

ENTITY Pong_Field IS
	PORT(
		x_value				:  IN    xType;    --! Display X-Pixel from VGA Sig. Gen
		y_value				:  IN    yType;    --! Display Y-Pixel from VGA Sig. Gen
		
		color_field			:	OUT	std_logic;	--! Output for VGA Sig. Gen
		top_left_x        :  OUT   xType;    --! Corner x-point top left
		top_left_y        :  OUT   yType;    --! Corner y-point top left
		top_right_x       :  OUT   xType;    --! Corner x-point top right
		top_right_y       :  OUT   yType;    --! Corner y point top right
		bottom_left_x     :  OUT   xType;    --! Corner x-point bottom left
		bottom_left_y     :  OUT   yType;    --! Corner y-point bottom left
		bottom_right_x    :  OUT   xType;    --! Corner x-point bottom right
		bottom_right_y    :  OUT   yType     --! Corner y-point bottom right
  );
END Pong_Field;

ARCHITECTURE behave OF Pong_Field IS
	
	signal top_left_xi       :  xType;     --! Corner x-point top left
	signal top_left_yi       :  yType;     --! Corner y-point top left
	signal top_right_xi      :  xType;     --! Corner x-point top right
	signal top_right_yi      :  yType;     --! Corner y point top right
	signal bottom_left_xi    :  xType;     --! Corner x-point bottom left
	signal bottom_left_yi    :  yType;     --! Corner y-point bottom left
	signal bottom_right_xi   :  xType;     --! Corner x-point bottom right
	signal bottom_right_yi   :  yType;     --! Corner y-point bottom right
	
	signal centerline_min_x  :  xType;     --! Cornerline min value
	signal centerline_max_x  :  xType;     --! Cornerline max value
	signal centerline_y      :  std_logic; --! Cornerline y flag
	signal centerline_flag   :  std_logic; --! Cornerline flag 
	
	constant line_width	    :	INTEGER RANGE 0 TO 31 := 5;  --! linewidth for the centerline
	constant distance        : INTEGER RANGE 0 TO 31 := 10; --! distance to the edge of the screen
	
BEGIN
	
	-- Coordinates of the corner points
	top_left_xi      <= distance;
	top_left_yi      <= distance;
	top_right_xi     <= DISPLAY_WIDTH - distance;
	top_right_yi     <= distance;
	bottom_left_xi   <= distance;
	bottom_left_yi   <= DISPLAY_HEIGHT - distance;
	bottom_right_xi  <= DISPLAY_WIDTH - distance;
	bottom_right_yi  <= DISPLAY_HEIGHT - distance;
 
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
									 (y_value > 411 AND y_value <= 423)  OR
									 (y_value > 458 AND y_value <= 470)  ELSE '1';		  
	 
	centerline_flag <= '1' WHEN x_value >= centerline_min_x AND x_value <= centerline_max_x AND centerline_y = '1' ELSE
							 '0';
							  
	-- Value '1' --> White pixel
	-- Value '0' --> Black pixel
	color_field <= '1' WHEN x_value <= top_left_xi OR x_value >= top_right_xi   OR
	                        y_value <= top_left_yi OR y_value >= bottom_left_yi OR centerline_flag = '1'  ELSE '0';
	
	top_left_x    	<= top_left_xi;
	top_left_y    	<= top_left_yi;
	top_right_x   	<= top_right_xi;
	top_right_y   	<= top_right_yi;
	bottom_left_x 	<= bottom_left_xi;
	bottom_left_y 	<= bottom_left_yi;
	bottom_right_x <= bottom_right_xi;
	bottom_right_y <= bottom_right_yi;
	
END behave;