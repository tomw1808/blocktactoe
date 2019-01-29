var TicTacToe = artifacts.require("TicTacToe");

contract("TicTacToe", function(accounts) {
  it("should have an empty board at the beginning", function() {
    return TicTacToe.new({from: accounts[0], value: web3.utils.toWei("0.1", "ether")}).then(function(instance ) {
      return instance.getBoard.call();
    }).then(board => {
      assert.equal(board[0][0], 0, "The first row and column must be empty");
    }).catch(err => {
      console.log(err);
    })
  })
});
