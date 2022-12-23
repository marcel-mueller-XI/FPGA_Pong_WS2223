library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity paddle is 
generic(
	xpos : integer;
	plength : integer;
	pwidth : integer;
)

port(


	x,y : in std_logic_vector(9 downto 0);
	clk : in std_logic;
	reset : in std_logic;
	up, down : in std_logic;
	color_p : out std_logic;
	p_a_x, p_a_y, p_b_x, p_b_y : out std_logic_vector(1 downto 0);
);
end entity paddle;

architecture behave of paddle is
	signal;

begin

	process(Clk, Reset)
	begin
	
	end


end architecture behave;

