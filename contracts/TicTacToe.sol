pragma solidity ^0.4.18;

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

    uint timeToReact = 3 minutes;
    uint gameValidUntil;

    address activePlayer;

    event PlayerJoined(address player);
    event NextPlayer(address player);
    event GameOverWithWin(address winner);
    event GameOverWithDraw();
    event PayoutSuccess(address receiver, uint amountInWei);

    function TicTacToe() public payable {
        player1 = msg.sender;
        require(msg.value == gameCost);
        gameValidUntil = now+timeToReact;
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

        gameValidUntil = now + timeToReact;

        NextPlayer(activePlayer);
    }

    function getBoard() public view returns(address[3][3]) {
        return board;
    }

    function setWinner(address player) private {
        gameActive = false;
        //emit an event
        GameOverWithWin(player);
        uint balanceToPayOut = this.balance;
        if(player.send(balanceToPayOut) != true) {
            if(player == player1) {
                balanceToWithdrawPlayer1 = balanceToPayOut;
            } else {
                balanceToWithdrawPlayer2 = balanceToPayOut;
            }
        } else {
            PayoutSuccess(player, balanceToPayOut);
        }
        //transfer money to the winner
    }

    function withdrawWin() public {
        if(msg.sender == player1) {
            require(balanceToWithdrawPlayer1 > 0);
            uint balanceToTransfer = balanceToWithdrawPlayer1;
            balanceToWithdrawPlayer1 = 0;
            player1.transfer(balanceToTransfer);

            PayoutSuccess(player1, balanceToTransfer);
        } else {

            require(balanceToWithdrawPlayer2 > 0);
            uint balanceToTransfer = balanceToWithdrawPlayer2;
            balanceToWithdrawPlayer2 = 0;
            player2.transfer(balanceToTransfer);
            PayoutSuccess(player2, balanceToTransfer);
        }
    }

    function setDraw() private {
        gameActive = false;
        GameOverWithDraw();

        uint balanceToPayOut = this.balance/2;

        if(player1.send(balanceToPayOut) == false) {
            balanceToWithdrawPlayer1 += balanceToPayOut;
        } else {
            PayoutSuccess(player1, balanceToPayOut);
        }
        if(player2.send(balanceToPayOut) == false) {
            balanceToWithdrawPlayer2 += balanceToPayOut;
        } else {
            PayoutSuccess(player2, balanceToPayOut);
        }

    }

    function emergecyCashout() public {
        require(gameValidUntil < now);
        require(gameActive);
        setDraw();
    }


    function setStone(uint8 x, uint8 y) public {
        require(board[x][y] == address(0));
        require(gameValidUntil > now);
        assert(gameActive);
        assert(x < boardSize);
        assert(y < boardSize);
        require(msg.sender == activePlayer);
        board[x][y] = msg.sender;
        movesCounter++;
        gameValidUntil = now + timeToReact;

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
