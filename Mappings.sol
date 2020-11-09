pragma solidity 0.5.12;

contract Structs {

    struct Person {
        string name;
        uint age;
        bool adult;
    }

    mapping(address => Person) private people;

    function createPerson(string memory name, uint age) public {
        address creator = msg.sender;

        Person memory newPerson;
        newPerson.name = name;
        newPerson.age = age;
        newPerson.adult = age > 18;

        people[creator] = newPerson;

    }

    function getPerson() public view returns(string memory name, uint age, bool adult) {
        return (people[msg.sender].name, people[msg.sender].age, people[msg.sender].adult);
    }

}