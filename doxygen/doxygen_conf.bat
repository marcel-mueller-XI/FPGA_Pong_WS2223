@echo Starte Doxywizard mit der Doxyfile Configuration
@echo @todo Leider blockiert hier noch Doxywizard die Batch Beendigung 
@echo obwohl "start" verwendet wurde

rem start doxywizard.exe Doxyfile

@echo Aber mit Dateisystem Verknuepfung der Endung .doxy mit doxywizard klappt es
start Doxyfile.doxy
