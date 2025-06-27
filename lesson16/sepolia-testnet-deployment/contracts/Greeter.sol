// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Greeter {
    string private greeting;

    event ResetGreeting(string oldGreeting, string newGreeting);

    constructor(string memory _initialGreeting) {
        greeting = _initialGreeting;
    }

    function greet() public view returns (string memory) {
        return greeting;
    }

    function setGreeting(string memory _newGreeting) public {
        emit ResetGreeting(greeting, _newGreeting);
        greeting = _newGreeting;
    }
}