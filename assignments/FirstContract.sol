pragma solidity ^0.5.0;

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
    
    constructor() public {
        myAddress = msg.sender;
        someValue.counter = 5;
        someValue.from = msg.sender;
        
        someValueArray[0].counter = 5;
        
        timeStamp = now;
        
    }
    
    function setMyUint8(uint8 myUintArgument) public {
        require(msg.sender == myAddress, "Address not MyAddress");
        //uint daysMustHaveBeenPass = 5;
        //require((timeStamp + (daysMustHaveBeenPass * 1 days)) < now);
        require((timeStamp + 10 seconds) < now, "Some time must pass");
        myUint8 = myUintArgument;
        emit MyEvent(myUint8);
    }
    
    
    /** This does not work anymore in Solidity 0.5.0, I had to remove it! */
    /*
    function getSomeValueArray() public view returns(MyStruct[2] memory) {
        return someValueArray;
    }*/
    
    function increase() public {
        someValue.counter++;
    }
    
    function getBoard() public view returns(uint[3][3] memory) {
        return board;
    }
    
    function fundMyContract() public payable {
        
    }
    
    function withdrawal() public {
        msg.sender.transfer(address(this).balance);
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
