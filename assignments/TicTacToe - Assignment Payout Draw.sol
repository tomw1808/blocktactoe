pragma solidity ^0.5.0;

contract TicTacToe {
    uint constant public gameCost = 0.1 ether;
    
    uint8 public boardSize = 3;
    uint8 movesCounter;
    
    bool gameActive;
    
    address[3][3] board;
    
    address payable public player1;
    address payable public player2;
    
    uint balanceToWithdrawPlayer1;
    uint balanceToWithdrawPlayer2;
    
    address activePlayer;
    
    event PlayerJoined(address player);
    event NextPlayer(address player);
    event GameOverWithWin(address winner);
    event GameOverWithDraw();
    event PayoutSuccess(address receiver, uint amountInWei);
    
    constructor() public payable {
        player1 = msg.sender;
        require(msg.value == gameCost, "Submit some money, aborting");
    }
    
    function joinGame() public payable {
        assert(player2 == address(0));
        gameActive = true;
        
        require(msg.value == gameCost, "Submit some money, aborting");
        
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
    
    function setWinner(address payable player) private {
        gameActive = false;
        //emit an event
        emit GameOverWithWin(player);

        /**
        * In Real-World application consider removing the player.send part completely and let the player
        * Withdraw the money later on!
         */
        if(!player.send(address(this).balance)) {
            if(player == player1) {
                balanceToWithdrawPlayer1 = address(this).balance;
            } else {
                balanceToWithdrawPlayer2 = address(this).balance;
            }
        } else {
            emit PayoutSuccess(player, address(this).balance);
        }
        //transfer money to the winner
    }
    
    function withdrawWin() public {
        if(msg.sender == player1) {
            require(balanceToWithdrawPlayer1 > 0);
            balanceToWithdrawPlayer1 = 0;
            player1.transfer(balanceToWithdrawPlayer1);
            
            emit PayoutSuccess(player1, balanceToWithdrawPlayer1);
        } else {
            
            require(balanceToWithdrawPlayer2 > 0);
            balanceToWithdrawPlayer2 = 0;
            player2.transfer(balanceToWithdrawPlayer2);
            emit PayoutSuccess(player2, balanceToWithdrawPlayer2);
        }
    }
    
    function setDraw() private {
        gameActive = false;
        emit GameOverWithDraw();
        
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
        if(movesCounter == (boardSize**2)) {
            //draw
            setDraw();
            return;
        }
        
        if(activePlayer == player1) {
            activePlayer = player2;
        } else {
            activePlayer = player1;
        }
        emit NextPlayer(activePlayer);
    }
}