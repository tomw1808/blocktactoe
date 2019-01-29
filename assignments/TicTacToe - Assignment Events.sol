pragma solidity ^0.5.0;

contract TicTacToe {
    uint8 public boardSize = 3;
    uint8 movesCounter;
    
    bool gameActive;
    
    address[3][3] board;
    
    address public player1;
    address public player2;
    
    address activePlayer;
    
    event PlayerJoined(address player);
    event NextPlayer(address player);
    
    constructor() public {
        player1 = msg.sender;
    }
    
    function joinGame() public {
        assert(player2 == address(0));
        gameActive = true;
        player2 = msg.sender;
        emit PlayerJoined(player2);
        if(block.number % 2 == 0) {
            activePlayer = player2;
        } else {
            activePlayer = player1;
        }
        emit NextPlayer(activePlayer);
    }
    
    function getBoard() public view returns(address[3][3] memory) {
        return board;
    }
    
    function setWinner(address player) private {
        gameActive = false;
        //emit an event
        //transfer money to the winner
    }
    
    function setDraw() private {
        gameActive = false;
    }
    
    function setStone(uint8 x, uint8 y) public {
        require(board[x][y] == address(0), "Field not empty, aborting");
        assert(x < boardSize);
        assert(y < boardSize);
        require(msg.sender == activePlayer, "Player not the active player, aborting");
        board[x][y] = msg.sender;
        
        for(uint8 i = 0; i < boardSize; i++) {
            if(board[i][y] != activePlayer) {
                break;
            }
            //win
            if(i == boardSize - 1) {
                //winner
            }
        }
        for(uint i = 0; i < boardSize; i++) {
            if(board[x][i] != activePlayer) {
                break;
            }
            //win
            
            if(i == boardSize - 1) {
                //winner
            }
        }
        
        //diagonale
        if(x == y) {
            for(uint i = 0; i < boardSize; i++) {
                if(board[i][i] != activePlayer) {
                    break;
                }
                //win
                if(i == boardSize - 1) {
                    //winner
                }
            }
        }
        
        //anti-diagonale
        if((x+y) == boardSize-1) {
            for(uint i = 0; i < boardSize; i++) {
                if(board[i][(boardSize-1)-i] != activePlayer) {
                    break;
                }
                //win
                
                if(i == boardSize - 1) {
                    //winner
                }
            }
        }
        
        //draw
        
        if(activePlayer == player1) {
            activePlayer = player2;
        } else {
            activePlayer = player1;
        }
        emit NextPlayer(activePlayer);
    }
}