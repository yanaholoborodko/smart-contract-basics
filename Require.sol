pragma solidity 0.5.12;

contract Require {

    struct Person {
        string name;
        uint age;
        bool adult;
    }

    event personCreated(string name, bool adult);
    event personDeleted(string name, bool adult, address deletedBy);

    address public owner;
    uint public balance;

    modifier onlyOwner() {
        // check if the address who called the function is the owner of the smart contract
        require(msg.sender == owner, "Caller needs to be owner");
        _; //continue execution
    }

    modifier costs(uint cost) {
        require(msg.value >= cost);
        _;
    }


    // will only run once
    constructor() public {
        owner = msg.sender;
    }

    mapping(address => Person) private people;
    address[] private creators;


    function createPerson(string memory name, uint age) public payable costs(1 ether) {
        require(age < 150, "Age needs to be below 150");

        balance += msg.value;

        Person memory newPerson;
        newPerson.name = name;
        newPerson.age = age;
        newPerson.adult = age > 18;

        people[msg.sender] = newPerson;
        creators.push(msg.sender);
        //keccak256 is for hashing
        //below check is people[msg.sender] == newPerson (but you can`t compare two structs,
        // so we hash them and compare the outputs)
        assert(
            keccak256(abi.encodePacked(people[msg.sender].name, people[msg.sender].age, people[msg.sender].adult))
            == keccak256(abi.encodePacked(newPerson.name, newPerson.age, newPerson.adult)));

        emit personCreated(newPerson.name, newPerson.adult);
    }

    function getPerson() public view returns(string memory name, uint age, bool adult) {
        return (people[msg.sender].name, people[msg.sender].age, people[msg.sender].adult);
    }

    function deletePerson(address creator) public onlyOwner {
        string memory name = people[creator].name;
        bool adult = people[creator].adult;
        delete people[creator];
        assert(people[creator].age == 0);
        emit personDeleted(name, adult, msg.sender);
    }

    function getCreator(uint index) public view onlyOwner returns(address) {
        return creators[index];
    }

    function getCreatorsQty() public view onlyOwner returns(uint) {
        return creators.length;
    }

    function getBalance() public view returns(uint) {
        return owner.balance;
    }

}