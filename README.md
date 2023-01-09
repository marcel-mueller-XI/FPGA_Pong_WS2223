# FPGA Pong WS2223

## Definition des Koordinatensystems
Oben links ist der Ursprung des Koordinatensystems.  
Die Koordinaten sind beide positiv. Sprich die x-Koordinate wächst nach rechts und die y-Koordinate wächst nach unten.

## Definition des Datentypes für Koordinaten
Es wird ein INTEGER 

SUBTYPE xType IS integer RANGE 0 TO 1023;
SUBTYPE yType IS integer RANGE 0 TO 1023;

## Display Standard

Auflösung 480 x 640 pixel  
Frequenz 60Hz

## Packages für diverse Konstanten

Konstanten die die meisten brauchen und somit Kandidaten für das Package sind:  
[INTEGER] mit 10bit Breite  range 0 to 1024

- MAIN_CLOCK [INTEGER] = 25,175 Mhz
- COLOR_DEPTH [INTEGER] = 4bit

- DISPLAY_WIDTH [INTEGER]
- DISPLAY_LENGHT [INTEGER]
- BALL_DIAMETER [INTEGER]
- PADDLE_WIDTH [INTEGER]
- PADDLE_LENGTH [INTEGER]

- MAX_SCORE [INTEGER]
