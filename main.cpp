#include <iostream>
#include "TicTacToe_cli.hpp"

int main()
{
	tic::TicTacToe_cli thisMatch(tic::AI_Level::AI_MEDIUM);
	
	thisMatch.runGame();
	return 0;
}