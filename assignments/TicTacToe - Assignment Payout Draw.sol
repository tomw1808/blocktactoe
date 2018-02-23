pragma solidity ^0.4.19;

contract TicTacToe {
    uint constant public gameCost = 0.1 ether;
    
    uint8 public boardSize = 3;
    uint8 movesCounter;
    
    bool gameActive;
    
    address[3][3] board;
    
    address public player1;
    address public player2;
    
    uint balanceToWithdrawPlayer1;
    uint balanceToWithdrawPlayer2;
    
    address activePlayer;
    
    event PlayerJoined(address player);
    event NextPlayer(address player);
    event GameOverWithWin(address winner);
    event GameOverWithDraw();
    event PayoutSuccess(address receiver, uint amountInWei);
    
    function TicTacToe() public payable {
        player1 = msg.sender;
        require(msg.value == gameCost);
    }
    
    function joinGame() public payable {
        assert(player2 == address(0));
        gameActive = true;
        
        require(msg.value == gameCost);
        
        player2 = msg.sender;
        PlayerJoined(player2);
        if(block.number % 2 == 0) {
            activePlayer = player2;
        } else {
            activePlayer = player1;
        }
        
        NextPlayer(activePlayer);
    }
    
    function getBoard() public view returns(address[3][3]) {
        return board;
    }
    
    function setWinner(address player) private {
        gameActive = false;
        //emit an event
        GameOverWithWin(player);
        if(player.send(this.balance) != true) {
            if(player == player1) {
                balanceToWithdrawPlayer1 = this.balance;
            } else {
                balanceToWithdrawPlayer2 = this.balance;
            }
        } else {
            PayoutSuccess(player, this.balance);
        }
        //transfer money to the winner
    }
    
    function withdrawWin() public {
        if(msg.sender == player1) {
            require(balanceToWithdrawPlayer1 > 0);
            balanceToWithdrawPlayer1 = 0;
            player1.transfer(balanceToWithdrawPlayer1);
            
            PayoutSuccess(player1, balanceToWithdrawPlayer1);
        } else {
            
            require(balanceToWithdrawPlayer2 > 0);
            balanceToWithdrawPlayer2 = 0;
            player2.transfer(balanceToWithdrawPlayer2);
            PayoutSuccess(player2, balanceToWithdrawPlayer2);
        }
    }
    
    function setDraw() private {
        gameActive = false;
        GameOverWithDraw();
        
    }
    
    function setStone(uint8 x, uint8 y) public {
        require(board[x][y] == address(0));
        assert(gameActive);
        assert(x < boardSize);
        assert(y < boardSize);
        require(msg.sender == activePlayer);
        board[x][y] = msg.sender;
        movesCounter++;
        
        for(uint8 i = 0; i < boardSize; i++) {
            if(board[i][y] != activePlayer) {
                break;
            }
            //win
            if(i == boardSize - 1) {
                //winner
                setWinner(activePlayer);
                return;
            }
        }
        for(i = 0; i < boardSize; i++) {
            if(board[x][i] != activePlayer) {
                break;
            }
            //win
            
            if(i == boardSize - 1) {
                //winner
                setWinner(activePlayer);
                return;
            }
        }
        
        //diagonale
        if(x == y) {
            for(i = 0; i < boardSize; i++) {
                if(board[i][i] != activePlayer) {
                    break;
                }
                //win
                if(i == boardSize - 1) {
                    //winner
                    setWinner(activePlayer);
                    return;
                }
            }
        }
        
        //anti-diagonale
        if((x+y) == boardSize-1) {
            for(i = 0; i < boardSize; i++) {
                if(board[i][(boardSize-1)-i] != activePlayer) {
                    break;
                }
                //win
                
                if(i == boardSize - 1) {
                    //winner
                    setWinner(activePlayer);
                    return;
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
        NextPlayer(activePlayer);
    }
}