// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract NGOFunding {
    
    address public owner;
    mapping(address => uint) public donations;
    uint public totalDonations;
    
    event DonationReceived(address indexed donor, uint amount);
    event FundsWithdrawn(address indexed NGO, uint amount);
    
    constructor() {
        owner = msg.sender; // NGO address
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the NGO can call this function");
        _;
    }
    
    // Function to receive donations from the public
    function donate() public payable {
        require(msg.value > 0, "Donation must be greater than zero");
        
        donations[msg.sender] += msg.value;
        totalDonations += msg.value;
        
        emit DonationReceived(msg.sender, msg.value);
    }
    
    // Function to withdraw funds by the NGO
    function withdraw(uint amount) public onlyOwner {
        require(amount <= address(this).balance, "Insufficient funds");
        
        payable(owner).transfer(amount);
        emit FundsWithdrawn(owner, amount);
    }
    
    // Get the contract balance
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
    
    // Get the donation amount by a specific address
    function getDonationAmount(address donor) public view returns (uint) {
        return donations[donor];
    }
}
