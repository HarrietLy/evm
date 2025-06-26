// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title A basic skeleton for a Rock, Paper, Scissors game.
 * @dev This contract is intentionally incomplete. Use it as a basis for design discussions.
 */
contract RockPaperScissors {

    enum Move { None, Rock, Paper, Scissors }

    struct Game {
        address payable player1;
        address payable player2;
        // How should the moves be stored to prevent cheating?
        // A simple `Move player1Move;` would be insecure.
        // What other state does the game need? e.g., to handle wagers and timeouts.
        uint wager;
        uint timeOutInSeconds;
        uint createdAt;

        //commitmentsmin hash bytes so cannot be read easily
        bytes32 player1Commitment;
        bytes32 player2Commitment;

        Move player1Move;
        Move player2Move;

        bool player1Revealed;
        bool player2Revealed;
        bool completed;

    }

    // How will you store and retrieve games? A mapping is a good choice.
    // answer: mapping key can be 'gameId' as a random UUID
    mapping(bytes32 => Game) public games;

    // It's good practice to emit events for important actions.
    event GameCreated(bytes32 indexed gameId, address indexed player1, address indexed player2, uint wager);
    event MoveCommitted(bytes32 indexed gameId, address indexed player);
    event MoveRevealed(bytes32 indexed gameId, address indexed player, Move move);
    event GameRevealed(bytes32 indexed gameId, address winner, uint winningAmount);


    function createGame(address payable _player2, uint _timeOutInSeconds) public payable  returns (bytes32){
        // - Should require a wager (msg.value > 0).
        // - How do you generate a unique ID for the game?
        // - What initial state needs to be stored?
        require(msg.value>0, "Must wager some eth!");
        bytes32 gameId = keccak256(abi.encodePacked(msg.sender, _player2, block.timestamp));
        Game storage game = games[gameId];
        game.player1 = payable(msg.sender);
        game.player2 = _player2;
        game.timeOutInSeconds = _timeOutInSeconds;
        game.createdAt = block.timestamp;
        emit GameCreated(gameId, msg.sender, _player2, msg.value);
        return gameId;

    }
    // TODO: joinGame(bytes32 gameId) for the second play to join and send msg.value the same amount as game.wager else
    // game is locked, cannot commit any move

    function commitMove(bytes32 gameId, bytes32 commitment) public {
        // - This function should allow a player to commit to their move without revealing it.
        // - What data should the player send? (Hint: not the move itself)
        // answer: send some hash code in bytes32 that s derived from game
        Game storage game = games[gameId];
        require(!game.completed, 'game ended');
        require(msg.sender == game.player1 || msg.sender == game.player2, "Not a player");
        if (msg.sender==game.player1){
            require(game.player1Commitment==0, 'player 1 already committed');
            game.player1Commitment = commitment;
        }else{
            require(game.player2Commitment==0, "player2 already committed");
            game.player2Commitment = commitment;
        }
        emit MoveCommitted(gameId, msg.sender);

    }

    function revealMove(bytes32 gameId, Move move, string memory secret) public {
        // - This function is called after both players have committed.
        // - It should take the actual move and the "secret" used to commit it.
        // - The contract must verify that the revealed move matches the commitment.
        // - Once both moves are revealed, it determines the winner and pays out the wager.
        // pull out the commitment and check that it matched the revealed move in input
        Game storage game = games[gameId];
        require(!game.completed, 'game ended');
        require(move ==Move.Rock|| move ==Move.Paper || move == Move.Scissors," invalid move");
        bytes32 hash = keccak256(abi.encodePacked(move, secret));
        if (msg.sender == game.player1){
            require(hash == game.player1Commitment,"revealed move is not same as committed");
            game.player1Move = move;
            game.player1Revealed = true;
        } else if (msg.sender == game.player2){
            require(hash == game.player2Commitment, "revealed move is not the same as committed");
            game.player2Move = move;
            game.player2Revealed = true;
        } else {
            revert("Not a player");
        }
        emit MoveRevealed(gameId, msg.sender, move);
        if (game.player1Revealed && game.player2Revealed){
            resolveGame(gameId);
        }
    }

    function resolveGame(bytes32 gameId) private{
        Game storage game = games[gameId];
        require(!game.completed, 'game ended');
        address payable winner;
        uint winningAmount;

        if (game.player1Move==game.player2Move){
            game.player1.transfer(game.wager);
            game.player2.transfer(game.wager);
            winningAmount =0;
        } else if (
            (game.player1Move == Move.Rock && game.player2Move == Move.Scissors) ||
            (game.player1Move == Move.Paper && game.player2Move == Move.Rock) ||
            (game.player1Move == Move.Scissors && game.player2Move == Move.Paper)
        ){
            winner = game.player1;
            winner.transfer(2* game.wager);
            winningAmount = game.wager;
        } else {
            winner = game.player2;
            winner.transfer(2* game.wager);
            winningAmount = game.wager;
        }

        game.completed=true;
        emit GameRevealed(gameId, winner, winningAmount);
    }

    function reclaimWager(/* Parameters? */) public {
        // - This function should handle timeouts.
        // - A player should only be able to call this after a certain amount of time has passed
        //   and the opponent has failed to act aka did not commit or reveal move
    }
}