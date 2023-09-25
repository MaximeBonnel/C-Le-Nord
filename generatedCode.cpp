#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <vector>

int main(int argc, char** argv){
	// "ceci est un exmple de code en C-le-Nord !"
	int var1 = 0.000000;
	int var2 = 5.000000;
	// "les imbrications de bloucles fonctionnent, pour les boucles for, if et while, mais ça ne marche pas quand on les mélange (while dans un if par exemple)"
	for(	int var3 = 0.000000; var3 < var2; var3++){
		for(	int var4 = 0.000000; var4 < var2; var3++){
		}
	}
	if(var1 == var2){
		printf("var1 est égal à var2");
		if(var1 != var2){
			printf("var1 est différent de var2");
		}
	}
	while(var1 <= var2){
		var1 = var2;
	}
	// "les fonctions scanf, printf sont utilisables"
	std::string userVar;
	scanf("Entrez du texte", &userVar);
	// "les tableaux dynamiques sont implémentés"
	std::vector<std::string> stringTab;
	stringTab.push_back("ceci est un");
	stringTab.push_back("exemple");
	// "les calculs de base sont fonctionnels"
	double var5 = 5.000000 * 10.000000;
	var5 = 18.000000 - 3.000000;
}
