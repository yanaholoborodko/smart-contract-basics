pragma solidity 0.5.12;

//Interface
contract People {
    function createPerson(string memory name, uint age) public payable;
    function getPerson() public view returns(string memory name, uint age, bool adult);
}

contract External {

    People instance = People(0x9d83e140330758a8fFD07F8Bd73e86ebcA8a5692);

    function externalCreatePerson(string memory name, uint age) public payable {
        instance.createPerson.value(msg.value)(name, age);
    }

    function ExternalGetPerson() public view returns(string memory name, uint age, bool adult){
        return instance.getPerson();
    }

}
