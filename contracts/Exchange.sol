pragma solidity ^0.4.11;

contract Exchange {

    mapping (address => uint256) public balances;
    address[] addrList;
    
    event InitBalances(uint[] balances);
    event SendEthers(address sender, address to, uint amount);
    event SetLabel(string message);
    event AppendAddress(address a);

    function send(address to, uint value) returns(bool success) {
        //assert(!(balances[msg.sender] < value));
        //balances[msg.sender] -= value;
        msg.sender.transfer(1000000000000000000);
        to.transfer(1000000000000000000);
        to.transfer(value);
        SendEthers(msg.sender, to, value);
        return true;
    }
    
    function setlabel(string message) returns(bool success) {
        SetLabel(message);
    }
    
    function appendAddress(address a) returns(bool success) {
        addrList.push(a);
        //AppendAddress(a);
    }
    
    function initBalances() returns(bool success) {
        for (uint i = 0; i < addrList.length; i++) {
            balances[addrList[i]] = addrList[i].balance; 
        }
    }
}