pragma solidity 0.5.12;

contract Ownable {
    address internal owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller needs to be owner");
        _;
    }

    constructor() public {
        owner = msg.sender;
    }
}