pragma solidity 0.5.12;

contract Require {

    struct Person {
        string name;
        uint age;
        bool adult;
    }

    address public owner;

    // will only run once
    constructor() public {
        owner = msg.sender;
    }

    mapping(address => Person) private people;
    address[] private creators;


    function createPerson(string memory name, uint age) public {
        require(age < 150, "Age needs to be below 150");
        Person memory newPerson;
        newPerson.name = name;
        newPerson.age = age;
        newPerson.adult = age > 18;

        people[msg.sender] = newPerson;
        creators.push(msg.sender);
    }

    function getPerson() public view returns(string memory name, uint age, bool adult) {
        return (people[msg.sender].name, people[msg.sender].age, people[msg.sender].adult);
    }

    function deletePerson(address creator) public {
        // check if the address who called the function is the owner of the smart contract
        require(msg.sender == owner, "Caller needs to be owner");
        delete people[creator];
    }

    function getCreator(uint index) public view returns(address) {
        require(msg.sender == owner, "Caller needs to be owner");
        return creators[index];
    }

    function getCreatorsQty() public view returns(uint) {
        require(msg.sender == owner, "Caller needs to be owner");
        return creators.length;
    }

}