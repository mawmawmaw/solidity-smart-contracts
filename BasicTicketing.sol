// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.0;

contract BasicTicketing {
    address private owner;
    uint256 public ticketPrice = 0.1 ether;
    mapping (address => uint256) internal ticketHolders;

    constructor(){
        owner = address(msg.sender);
    }
    
    modifier isOwner(){
        require(msg.sender == owner, "You are not the owner!");
        _;
    }
    
    function buyTicket(uint256 _amount) public payable {
        require(msg.value >= ticketPrice * _amount, "Not enough money!");
        addTickets(msg.sender,_amount);
    }
    
    function useTicket(uint256 _amount) public  {
        subTickets(msg.sender,_amount);
    }
    
    function addTickets(address _user, uint256 _amount) internal {
        ticketHolders[_user] = ticketHolders[_user] + _amount;
    }
    
    function subTickets(address _user, uint256 _amount) internal {
        require(ticketHolders[_user] >= _amount, "You dont have enough tickets!");
        ticketHolders[_user] = ticketHolders[_user] - _amount;
    }
    
    function withdraw() public isOwner{
        (bool success, ) = payable(owner).call{value: address(this).balance}("");
        require(success);
    }
        
}