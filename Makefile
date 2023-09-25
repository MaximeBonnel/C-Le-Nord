all:
	bison -d C-le-Nord.y -o C-le-Nord.bison.cpp
	flex -o C-le-Nord.lex.cpp C-le-Nord.l
	g++ -w -o C-le-Nord C-le-Nord.lex.cpp C-le-Nord.bison.cpp
	rm C-le-Nord.lex.cpp C-le-Nord.bison.cpp C-le-Nord.bison.hpp
	./C-le-Nord C-le-Nord.code