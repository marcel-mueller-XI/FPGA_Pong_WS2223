--! @file		vga_controller.vhd
--! @brief		VGA Controller/Timing Specification
--! @details	Generates the horizontal and vertical synchronization signals for the VGA standard (640 X 480) at a refresh rate of 60 Hz. Therefore the pixel frequency is 25.175 MHz.
--!				The visiblea area is 640 X 480. In order to compensate for the time to reset the "deflection coils" a front and back porch is added for both the horizontal and vertical axes.
--!				In sum a complete frame consists of 800 x 525 pixels.
--! @author		Paul Schwarz, Sebastian Schmaus
--! @date		13.01.2023

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.PongPack.all;

entity vga_controller is
	port(
		Clk_vga	: in std_logic;						--! Clock for the pixel frequency of 25.175 MHz
		Reset		: in std_logic;						--! Asynchronous Reset
		HSync		: out std_logic;						--! Horizontal Synchronization Signal
		VSync		: out std_logic;						--! Vertical Synchronization Signal 
		x_out		: out xType;							--! x-coordinate of the visible area, starts at 1 and ends at 640
		y_out		: out yType;							--! y-coordinate of the visible area, starts at 1 and ends at 480
		blank		: out std_logic						--! Blank signal for differentiation between visible and not visible area. '0': not in visible area, '1': in visible area
	);
end entity vga_controller;

architecture behave of vga_controller is
	signal pixel_counter	: integer range 0 to 800 := 1;		--! Counter for all pixels of a horizontal line (800), counting starts at 1
	signal line_counter	: integer range 0 to 525 := 1;		--! Counter for all rows (525), counting starts at 1
begin
	
	--! Process for generating HSync, VSync and the coordinates
	sync_proc : process(Clk_vga, Reset)
	begin
		--! Synchronous part
		if (rising_edge(Clk_vga)) then
			if (Reset = '1') then 
				HSync				<= '1';
				VSync				<= '1';
				pixel_counter	<= 1;		-- resets to 1, 0 when counting starts at 0
				line_counter	<= 1;		-- resets to 1, 0 when counting starts at 0
				blank				<= '0';
		
			else 			
				--! In the visible area the values of the pixel and line counter correspond to the x- and y-coordinates since counting is started in the visible area
				if pixel_counter >= 1 and pixel_counter <= 640 and line_counter >= 1 and line_counter <= 480 then		-- >= 1, <= 640, >= 1, <= 480 when counting starts at 1
					x_out <= pixel_counter;
					y_out <= line_counter;
					blank <= '1';		--! Don't blank the screen when in visible area
					
				else
					blank <= '0';		--! Blank the screen when not in visible area
				end if;
				
				--! Resetting the pixel counter when the end of a line is reached
				if pixel_counter = 800 then		-- = 800 when counting starts at 1
					pixel_counter <= 1;				-- <= 1 when counting starts at 1
					
					--! Resetting the line counter when the end of the last line is reached
					if line_counter = 525 then		-- = 525 when counting starts at 1
						line_counter <= 1;			-- <= 1 when counting starts at 1
					--! Incrementing the line counter until the end of the last line is reached
					else
						line_counter <= line_counter + 1;
					end if;
				--! Incrementing the pixel counter until the end of a line is reached
				else
					pixel_counter <= pixel_counter + 1;
				end if;
				
				--! After the front porch (16 pixels, 0.6356 us) HSync is pulled down to low
				if pixel_counter = 657 then		-- = 657 when counting starts at 1
					HSync <= '0';
				--! After 96 pixels, 3.813 us HSync is pulled up again for the back porch (48 pixels, 1.907 us)
				elsif pixel_counter = 753 then	-- = 753 when counting starts at 1
					HSync <= '1';
				end if;
				
				--! After the front porch (10 lines, 0.318 ms) VSync is pulled down to low
				if line_counter = 491 then			-- = 491 when counting starts at 1
					VSync <= '0';
				--! After 2 lines, 0.0635 ms VSync is pulled up again for the back porch (33 lines, 1.049 ms)
				elsif line_counter = 493 then		-- = 493 when counting starts at 1
					VSync <= '1';
				end if;
				
			end if;
		end if;
	
	end process sync_proc;

end architecture behave;