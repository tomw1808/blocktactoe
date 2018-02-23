// Import the page's CSS. Webpack will know what to do with it.
import "../stylesheets/app.css";

// Import libraries we need.
import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract'
import $ from "jquery";

// Import our contract artifacts and turn them into usable abstractions.
import tictactoe_artifacts from '../../build/contracts/TicTacToe.json'

// MetaCoin is our usable abstraction, which we'll use through the code below.
var TicTacToe = contract(tictactoe_artifacts);

// The following code is simple to show off interacting with your contracts.
// As your needs grow you will likely need to change its form and structure.
// For application bootstrapping, check out window.addEventListener below.
var accounts;
var account;
var ticTacToeInstance;
var nextPlayerEvent;
var gameOverWithWinEvent;
var gameOverWithDrawEvent;
var arrEventsFired;

window.App = {
  start: function() {
    var self = this;

    // Bootstrap the MetaCoin abstraction for Use.
    TicTacToe.setProvider(web3.currentProvider);

    // Get the initial account balance so it can be displayed.
    web3.eth.getAccounts(function(err, accs) {
      if (err != null) {
        alert("There was an error fetching your accounts.");
        return;
      }

      if (accs.length == 0) {
        alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.");
        return;
      }

      accounts = accs;
      account = accounts[0];
      arrEventsFired = [];

    });
  },
  useAccountOne: function() {
    account = accounts[1];
  },
  createNewGame: function() {
    TicTacToe.new({from:account, value:web3.toWei(0.1,"ether"), gas:3000000}).then(instance => {
      ticTacToeInstance = instance;

      console.log(instance);
      $(".in-game").show();
      $(".waiting-for-join").hide();
      $(".game-start").hide();
      $("#game-address").text(instance.address);
      $("#waiting").show();

      var playerJoinedEvent = ticTacToeInstance.PlayerJoined();

      playerJoinedEvent.watch(function(error, eventObj) {
        if(!error) {
          console.log(eventObj);
        } else {
          console.error(error);
        }
        $(".waiting-for-join").show();
        $("#opponent-address").text(eventObj.args.player);
        $("#your-turn").hide();
        playerJoinedEvent.stopWatching();

      });
      App.listenToEvents();
      console.log(instance);
    }).catch(error => {
      console.error(error);
    })
  },
  joinGame: function() {
    var gameAddress = prompt("Address of the Game");
    if(gameAddress != null) {
      TicTacToe.at(gameAddress).then(instance => {
        ticTacToeInstance = instance;

        App.listenToEvents();

        return ticTacToeInstance.joinGame({from:account, value:web3.toWei(0.1, "ether"), gas:3000000});
      }).then(txResult => {
        $(".in-game").show();
        $(".game-start").hide();
        $("#game-address").text(ticTacToeInstance.address);
        $("#your-turn").hide();
        ticTacToeInstance.player1.call().then(player1Address => {
          $("#opponent-address").text(player1Address);
        })
        console.log(txResult);
      })
    }
  },
  listenToEvents: function() {
    nextPlayerEvent = ticTacToeInstance.NextPlayer();
    nextPlayerEvent.watch(App.nextPlayer);

    gameOverWithWinEvent = ticTacToeInstance.GameOverWithWin();
    gameOverWithWinEvent.watch(App.gameOver);

    gameOverWithDrawEvent = ticTacToeInstance.GameOverWithDraw();
    gameOverWithDrawEvent.watch(App.gameOver);
  },
  nextPlayer: function(error, eventObj) {
    if(arrEventsFired.indexOf(eventObj.blockNumber) === -1) {
      arrEventsFired.push(eventObj.blockNumber);
      App.printBoard();
      console.log(eventObj);

      if(eventObj.args.player == account) {
        //our turn
        /**
        Set the On-Click Handler
        **/
        for(var i = 0; i < 3; i++) {
          for(var j = 0; j < 3; j++) {
            if($("#board")[0].children[0].children[i].children[j].innerHTML == "") {
              $($("#board")[0].children[0].children[i].children[j]).off('click').click({x: i, y:j}, App.setStone);
            }
          }
        }
        $("#your-turn").show();
        $("#waiting").hide();
      } else {
        //opponents turn

        $("#your-turn").hide();
        $("#waiting").show();
      }

    }
  },
  gameOver: function(err, eventObj) {
    console.log("Game Over", eventObj);
    if(eventObj.event == "GameOverWithWin") {
      if(eventObj.args.winner == account) {
        alert("Congratulations, You Won!");
      } else {
        alert("Woops, you lost! Try again...");
      }
    } else {
      alert("That's a draw, oh my... next time you do beat'em!");
    }


    nextPlayerEvent.stopWatching();
    gameOverWithWinEvent.stopWatching();
    gameOverWithDrawEvent.stopWatching();

    for(var i = 0; i < 3; i++) {
      for(var j = 0; j < 3; j++) {
            $("#board")[0].children[0].children[i].children[j].innerHTML = "";
      }
    }

      $(".in-game").hide();
      $(".game-start").show();
  },
  setStone: function(event) {
    console.log(event);

    for(var i = 0; i < 3; i++) {
      for(var j = 0; j < 3; j++) {
        $($("#board")[0].children[0].children[i].children[j]).prop('onclick',null).off('click');
      }
    }

    ticTacToeInstance.setStone(event.data.x, event.data.y, {from: account}).then(txResult => {
      console.log(txResult);
      App.printBoard();
    })
  },
  printBoard: function() {
    ticTacToeInstance.getBoard.call().then(board => {
      for(var i=0; i < board.length; i++) {
        for(var j=0; j < board[i].length; j++) {
          if(board[i][j] == account) {
            $("#board")[0].children[0].children[i].children[j].innerHTML = "X";
          } else if(board[i][j] != 0) {
              $("#board")[0].children[0].children[i].children[j].innerHTML = "O";
          }
        }
      }
    });
  }
};

window.addEventListener('load', function() {
  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    console.warn("Using web3 detected from external source. If you find that your accounts don't appear or you have 0 MetaCoin, ensure you've configured that source properly. If using MetaMask, see the following link. Feel free to delete this warning. :) http://truffleframework.com/tutorials/truffle-and-metamask")
    // Use Mist/MetaMask's provider
    window.web3 = new Web3(web3.currentProvider);
  } else {
    console.warn("No web3 detected. Falling back to http://127.0.0.1:9545. You should remove this fallback when you deploy live, as it's inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask");
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    window.web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:9545"));
  }

  App.start();
});
