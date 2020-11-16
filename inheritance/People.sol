import "./Ownable.sol";
pragma solidity 0.5.12;

contract People is Ownable {

    struct Person {
        string name;
        uint age;
        bool adult;
    }

    event personCreated(string name, bool adult);
    event personDeleted(string name, bool adult, address deletedBy);

    uint public balance;

    modifier costs(uint cost) {
        require(msg.value >= cost);
        _;
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

        address payable creator = msg.sender;
        creator.send(10 ether);
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

    function withdrawAll() public onlyOwner returns(uint) {
        uint toTransfer = balance;
        balance = 0;
        // msg.sender.transfer(toTransfer);
        if(msg.sender.send(10 ether)) {
            return toTransfer;
        } else {
            balance = toTransfer;
            return 0;
        }
    }

}