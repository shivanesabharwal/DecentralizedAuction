// Lock the version.
pragma solidity 0.4.15;

/* This is the main contract that implements the decentralized auction.
Anyone can put up a good to be sold on the market for a starting bid.
from there, interested users can bid higher if they would like to, and
after a user selected time, the item is automatically shipped to the highest 
bidder and the seller receives the money. */

contract DecentralizedAuction {
	uint public itemCount;
	string public test;
	// Structs
	struct Item {
		string name;
		address owner;
		address currentHighestBidder;
		uint startingPrice;
		uint currentBid;
		uint ID;
		uint blockDeadline;
		Status status;
	}

	enum Status {Active, Complete}


	// Global variables
	mapping(uint => Item) items;
	mapping(address => uint) refunds;

	// Events
	event ItemCreated(uint ID);
	event ItemSold(uint ID);

	// Modifiers
	modifier notOwner(address owner) {
		require(msg.sender != owner);
		_;
	}
	modifier hasRefund() {
		require(refunds[msg.sender] > 0);
		 _;
	}
	modifier higherBid(uint value) {
		require(msg.value > value);
		_;
	}
	modifier isActive(Status status) {
		require(status == Status.Active);
		_;
	}
	modifier isOwner(address owner) {
		require(msg.sender == owner);
		_;
	}
	modifier noCurrentBid(uint currentBid) {
		require(currentBid != 0);
		_;
	}

	// Initialize contract
	function DecentralizedAuction() {
		itemCount = 0;
	}

	//test function
	function increment() returns (uint){
		itemCount++;
		return itemCount;
	}

	function setString(string _greeting) {
		test = _greeting;
	}

	function stringe() constant returns (string) {
		return test;
	}

	// Functions
	function createItem(string _name, uint _startingPrice, uint _blockDeadline) {
		itemCount++;
		ItemCreated(itemCount);
		items[itemCount] = Item({
			name: _name,
			currentHighestBidder: msg.sender,
			owner: msg.sender,
			startingPrice: _startingPrice,
			currentBid: 0,
			ID: itemCount,
			status: Status.Active,
			blockDeadline: _blockDeadline
		});
	}

	function placeBid(uint ID) payable 
	notOwner(items[ID].owner) higherBid(items[ID].currentBid) isActive(items[ID].status) {
		address lastBidder = items[ID].currentHighestBidder;
		uint lastBid = items[ID].currentBid;
		items[ID].currentHighestBidder = msg.sender;
		items[ID].currentBid = msg.value;
		refunds[lastBidder] += lastBid;
	}

	function checkRefund() returns (bytes32) {
		bytes32 answer = "";
		if (refunds[msg.sender] > 0) {
			answer = stringToBytes32("Claim your money!");
		} 
		else {
			answer = stringToBytes32("You have no refund available.");
		}
		return answer;
	}

	/* function printRefund(string answer) returns (bytes) {
		return answer;
	} */

	function getRefund() 
	hasRefund() {
		msg.sender.transfer(refunds[msg.sender]);
	}

	// If no one has bid, the owner may end the auction at any time.
	function endAuctionEarly(uint ID) 
	isOwner(items[ID].owner) isActive(items[ID].status) noCurrentBid(items[ID].currentBid) {
		items[ID].status = Status.Complete;
		ItemSold(ID);
	}

	// If there is a highest bid, the user may only end the auction
	// after blockDeadline.
	function endAuction(uint ID)
	isOwner(items[ID].owner) isActive(items[ID].status) {
		require(block.number > items[ID].blockDeadline);
		items[ID].status = Status.Complete;
		refunds[items[ID].owner] += items[ID].currentBid;
		items[ID].owner = items[ID].currentHighestBidder;
		ItemSold(ID);
	}

	// Utility
	function bytes32ToString (bytes32 data) internal returns (string) {
    bytes memory bytesString = new bytes(32);
    for (uint j=0; j<32; j++) {
        byte char = byte(bytes32(uint(data) * 2 ** (8 * j)));
        if (char != 0) {
            bytesString[j] = char;
        }
    }
    return string(bytesString);
	}

	function stringToBytes32(string memory source) returns (bytes32 result) {
	    assembly {
	        result := mload(add(source, 32))
	    }
	}

}