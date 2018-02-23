pragma solidity ^0.4.19;

contract TicTacToe {
    bool public myBool = false;
    
    address public myAddress;
    
    uint8 public myUint8;
    uint256 myUint256;
    
    uint[3][3] board;
    
    string myString = "myString";
    bytes myBytes = "myString";
    
    struct MyStruct {
        uint counter;
        address from;
        bool isSet;
    }
    MyStruct public someValue;
    MyStruct[2] public someValueArray;
    
    event MyEvent(uint8 myNewUint);
    
    uint timeStamp;
    
    function TicTacToe() public {
        myAddress = msg.sender;
        someValue.counter = 5;
        someValue.from = msg.sender;
        
        someValueArray[0].counter = 5;
        
        timeStamp = now;
        
    }
    
    function setMyUint8(uint8 myUintArgument) public {
        require(msg.sender == myAddress);
        //uint daysMustHaveBeenPass = 5;
        //require((timeStamp + (daysMustHaveBeenPass * 1 days)) < now);
        require((timeStamp + 10 seconds) < now);
        myUint8 = myUintArgument;
        MyEvent(myUint8);
    }
    
    
    function getSomeValueArray() public view returns(MyStruct[2]) {
        return someValueArray;
    }
    
    function increase() public {
        someValue.counter++;
    }
    
    function getBoard() public view returns(uint[3][3]) {
        return board;
    }
    
    function fundMyContract() public payable {
        
    }
    
    function withdrawal() public {
        msg.sender.transfer(this.balance);
    }
    
    function setMyBoolean(bool myBoolArgument) public {
        if(msg.sender == myAddress) {
            myBool = myBoolArgument;
        }
    }
    
    function getMyBoolean() public view returns(bool) {
        return myBool;
    }
}
