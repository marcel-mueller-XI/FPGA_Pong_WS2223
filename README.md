# FPGA Pong WS2223

## Festlegung des Koordinatensystems
Oben links ist der Ursprung des Koordinatensystems.  
Die Koordinaten sind beide positiv. Sprich die x-Koordinate wächst nach rechts und die y-Koordinate wächst nach unten.

## Festlegung des Datentypes für Koordinaten
<code>SUBTYPE xType IS integer RANGE 0 TO 1023;  
SUBTYPE yType IS integer RANGE 0 TO 1023;</code>

## Display Standard
Auflösung 480 x 640 pixel  
Frequenz 60Hz

## Package "PongPack" für diverse Konstanten
Das Packages wird wie folgt eingebunde:  
<code>library work;  
use work.PongPack.all;</code>

Konstanten die im Package enthalten sind:
- MAIN_CLOCK [INTEGER] = 25,175 Mhz
- COLOR_DEPTH [INTEGER] = 4bit

- DISPLAY_WIDTH [INTEGER]
- DISPLAY_LENGHT [INTEGER]
- BALL_DIAMETER [INTEGER]
- PADDLE_WIDTH [INTEGER]
- PADDLE_LENGTH [INTEGER]

- MAX_SCORE [INTEGER]
