pragma solidity >=0.4.21 <0.7.0;

contract Accounts{
	struct Account{
		address addr;
		bool typee;//0 for user, 1 for org
	}
	Account [] accounts;
	constructor() public{
	}
	function getType(address _accountAddress) public return(bool){
		for(uint i =0; i<accounts.length; i+=1)
		{
			if(accounts[i] == _accountAddress)
				return accounts[i].typee;
		}

	}
	function add(address _accAddress, bool _type) public{
		Account memory acc = Account(_accAddress, _type);
		accounts.push(acc);
	}
}