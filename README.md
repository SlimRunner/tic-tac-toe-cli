# TicTacToe CLI
This is a refactor from the [original archived project in Visual Studio](https://github.com/SlimRunner/TicTacToe_Game). It provides an easy-to-use interface to manage tic tac toe matches that composes an AI class to play against which utilizes a naive implementation of minimax. 

## Changes from the original
This project now uses g++ and makefile to compile. The original was almost portable except for the fact that `size_t` was used in a few headers that did not include its  proper header. Additionally, the slightly less conventional style (for c++ at least) of inline curly braces is used here.

## Description of Classes
* **T3_Board:** This class takes care of correctly assigning symbols (`X`, `O`, or `empty`) to the corresponding cells. It also has bound checks. It does not enforce rules of any kind (e.g. you can override an `X` with an `O`)
* **T3_Match:** This class specializes (inherits) T3_Board. This class enforces correct assignment of symbols, disallows overriding, and automatically takes care of symbol selection (alternates symbol after every assignemnt).
* **TicTacToe_cli:** This is a command-line interface that displays the match current status and also prompts the user for input. It organizes input and output with menus.
* **TicTacToe_AI:** Takes care of determining a suitable move or moves to make based on a T3_Match object. The strategy to win is calculated using `MinMaxBoard` which returns a board with ranks so that the AI can decide which moves to make based on the selected difficulty. The first move is arbitrary to avoid the overhead of calculating a Minimax tree from an empty board (which returns a trivial pattern anyway).
* **MinMaxBoard:** Manages an array of 9x9 just like `T3_Board` but it uses that array to insert ranks based on what moves are suitable to win a tic tac toe match calculated using Minimax through a `get` function that recieves a `T3_Match` object to facilitate determining the state of the simulated match.