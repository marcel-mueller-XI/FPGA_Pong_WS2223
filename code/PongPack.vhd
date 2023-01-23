-- PongPack

package PongPack is
    SUBTYPE xType IS integer RANGE -1024 TO 1023;
    SUBTYPE yType IS integer RANGE -1024 TO 1023;

    constant MAIN_CLOCK     : integer := 25175000; --! in Hz = 39,722 ns
    constant COLOR_DEPTH    : integer := 4;
    constant DISPLAY_WIDTH  : integer := 640;
    constant DISPLAY_HEIGHT : integer := 480;
    constant BALL_DIAMETER  : integer := 20;
    constant PADDLE_WIDTH   : integer := 20;
    constant PADDLE_HEIGHT  : integer := 60;
    constant MAX_SCORE      : integer := 5;

end PongPack;

package body PongPack is
    
end PongPack;