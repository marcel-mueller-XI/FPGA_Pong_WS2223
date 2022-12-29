library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity paddle is 
generic(
	xpos : integer;
	ypos : integer;
	plength : integer;
	pwidth : integer
);

port(
	-- Inputs
	clk : in std_logic;
	reset : in std_logic;
	up, down : in std_logic;

	-- Outputs
	p_a_x, p_a_y, p_b_x, p_b_y : out std_logic_vector(9 downto 0);

	-- Interface for VGA Display Driver
	x,y : in std_logic_vector(9 downto 0);
	color_p : out std_logic
);
end entity paddle;

architecture behave of paddle is
	signal pos_a_x : std_logic_vector(9 downto 0);	--! pos_a defines upper left corner of paddle, pos_a_x defines x-position of this point
	signal pos_a_y : std_logic_vector(9 downto 0);	--! pos_a defines upper left corner of paddle, pos_a_y defines y-position of this point
	signal pos_b_x : std_logic_vector(9 downto 0);	--! pos_b defines lower right corner of paddle, pos_b_x defines x-position of this point
	signal pos_b_y : std_logic_vector(9 downto 0);	--! pos_b defines lower right corner of paddle, pos_b_y defines y-position of this point

	signal x_display : std_logic_vector(9 downto 0);
	signal y_display : std_logic_vector(9 downto 0);

begin
	x_display <= x;
	y_display <= y;

	color_p <= '1' when pos_a_x <= x_display and x_display <= pos_b_x and pos_a_y <= y_display and y_display <= pos_b_y else
			   '0';


--	clocked process(Clk, Reset)
--	begin
--	
--	end


end architecture behave;

