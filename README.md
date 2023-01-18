# FPGA_Pong_WS2223

@Toplevel: Die PLL Datein am Besten in dem IPcore Ordner für die Übersicht darin lassen.
           Ihr müsst lediglich die Dateie pll.qip inkludieren.
           
           Funktionsbeschreibung für die Entity:
           areset => asynchroner Reset
           inclk0 => Eingangsfrequenz 50MHz
           c0     => Ausgangsfrequenz 25.175MHz
           locked => Sobald die angestrebte Frequenz eingeschwungen ist, ist das Signal High
           
           
           Die Pinbelegungen für den VGA Anschluss sind in der qpf Datei drin
