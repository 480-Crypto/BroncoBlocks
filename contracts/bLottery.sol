pragma solidity ^0.4.11;

contract bLottery {
    
    struct ticket {
        address ownerAddress;
        string ticketNo;
    }
        
    mapping (address => uint) public ticketOwners;
    address[] public allOwners;
    address[] public pastWinners;
    address public lastWinner;
    uint public ticketsBought;
    uint public lotteryTotal;
    uint public totalWon;
    uint public timeStarted;
    uint public willLast;
    bool public lotteryOver;
    
    event TicketSold(address to, uint amount);
    event PayWinner(address to, uint amount);
    event Reset();
    event SetMessage(string message);
    
    modifier currentLottery() {
        require(now < timeStarted + willLast);
	    _;
    }
	modifier lotteryDone() {
		require(now > timeStarted + willLast);
		_;
	}

	function bLottery() {
		ticketsBought = 0;
		timeStarted = now;
		willLast = 10 seconds;
	}

	function () payable {
		sellTickets();
	}

	function sellTickets() payable currentLottery returns (bool success) {
		ticketOwners[msg.sender] = msg.value / (10**15);
		ticketsBought += ticketOwners[msg.sender];
		allOwners.push(msg.sender);
		lotteryTotal += msg.value;
		TicketSold(msg.sender, ticketOwners[msg.sender]);
		return true;
	}

	function reboot() lotteryDone returns (bool success) {
		lotteryOver = false;
		timeStarted = now;
		willLast = 2 minutes;
		Reset();
		return true;
	}

	function payWinner(address winner) internal currentLottery returns (bool success) {
		winner.transfer(lotteryTotal);
		PayWinner(winner, lotteryTotal);
		lotteryTotal = 0;
		Reset();
		return true;
	}

	function selectWinner() lotteryDone() returns (uint winningTicket) {
		uint random = uint(block.blockhash(block.number - 1)) % timeStarted + 1;
		lastWinner = allOwners[random];
		pastWinners.push(lastWinner);
		payWinner(lastWinner);
		return random;
	}

	function getOwnerBalance(address ownerAddress) constant returns (uint balance) {
		return ticketOwners[ownerAddress];
	}

	function getBalance() constant returns (uint) {
		return this.balance;
	}
	
	function setmessage(string message) returns (bool success) {
	    SetMessage(message);
	}

  	function timeLeft() returns (uint) {
      return timeStarted;
  }
}