The Challenge: Rock, Paper, Scissors on the Blockchain
The basic rules of the game are simple: two players choose one of three moves (Rock, Paper, or Scissors). The winner is determined by these rules:

Rock crushes Scissors
Scissors cuts Paper
Paper covers Rock
If both players choose the same move, it is a draw.

Your task is to design a system where two players can play a game of Rock, Paper, Scissors against each other.

The game should be fair, and it should be impossible for one player to cheat by knowing their opponent's move in advance.

For an extra challenge, consider how you would handle a wager (e.g., a small amount of ETH) that the winner receives.

The Task: Team Discussion and Design
In your teams, discuss the questions below. The primary goal is to identify potential problems and brainstorm solutions.

Think about the public and transparent nature of the blockchain. Every piece of data written to a smart contract is visible to everyone. How does this affect your design?

Key Discussion Points
1. State and Player Moves
How can the smart contract store the moves of each player? Remember that any data stored publicly is visible to everyone.

If Player 1 submits their move as a plain value (e.g., 1 for Rock), Player 2 could simply look at the transaction data on the blockchain before submitting their own winning move.

This is a form of front-running. How can you prevent this?
# answer: when player 1 submit their move, the move will be 'encrypted' using a hash function so that the move wont be stored as plain text in the contract state. When both players have submitted their move, we can decrypt the move then

2. Committing to a Move
Given the problem above, how can a player commit to a move without actually revealing what that move is until a later stage? Think about how you could use cryptography to your advantage.

# answer: we can use a hash function taking in the current timestamp of the submission because the timestamp is unique, to encrupt the move at submission. When both players have submitted their encrypted moves, we can decrypt the two at the same time and resolve the game

3. Game Logic and Determining the Winner
Once both players have revealed their moves, how does the contract determine the winner? Write down the logic for this.

What information does the contract need to have stored to make this decision?
# answer: the contract needs to store the game player 1 move and player 2 move to determine the winner
# if the move of player 1 is same as player2, there is no winner

4. Liveness and Timeouts
What happens if Player 1 commits their move, but Player 2 never shows up to play? Or what if Player 2 commits their move, but Player 1 never reveals theirs to finish the game?

How can you add a mechanism to the contract to handle inactive players and allow a participant to reclaim their stake?

# implement a public function for a player to reclaim their wager if a certain time has eslapsed from the game created timestamp and either one of the player has not submitted or reveal their move

5. Gas Costs and Efficiency
Every action that changes the state of the blockchain (like creating a game or submitting a move) costs gas. Consider the steps a user has to take in your proposed design.

How many separate transactions does each player need to send?
# answer: createGame and put wager, commit move, reveal move => each player needs to send three transactions to the contract
Which functions are likely to be the most expensive in terms of gas? 
# answer: writing game with player1 and player 2 encrypted move is expensive, the commit and reveal move functions will use multiple writes hence consuming most gas
Can you think of any ways to make the process more efficient?
# answer minimize variable in the Game struct, for eg it does not need to store decrypted move, just the encrypted one will do because decryption can be done on the fly within the function
