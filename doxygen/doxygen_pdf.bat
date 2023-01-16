@echo Make PDF File

call doxygen\latex\make.bat

@echo Open PDF Dokumentation
start doxygen\latex\refman.pdf 

