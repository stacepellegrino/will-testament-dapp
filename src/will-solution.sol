pragma solidity >= 0.7.0 < 0.9.0;

contract Will {

	address owner;
	uint fortune;
	bool deceased;

	constructor() payable public {
		owner = msg.sender;	// msg sender represents address being called
		fortune = msg.value;	//msg value tells us how much ether is being sent  
	}

	// create modifier so the only person who can call the contract is the owner
	modifier onlyOwner {
		require(msg.sender == owner);
		_;
	}

	// only allocate funds if owner is deceased
	modifier mustBeDeceased {
		require(deceased == true);
		_;
	}    

	// list of family wallets
	address payable[] familyWallets;

	// map through inheritance
	mapping(address => uint) inheritance;

	// set inheritance for each address 
	function payout() private mustBeDeceased {
		for (uint i = 0; i < familyWallets.length; i++) {
			// transferring funds from contract address to reciever address
			familyWallets[i].transfer(inheritance[familyWallets[i]]);
		}
	}

	// oracle triggers payout upon contract owner becoming deceased
	function hasDeceased() public onlyOwner {
		deceased = true;
		payout();
	}
}
