pragma solidity >=0.4.21 <0.7.0;

contract Accounts{
	struct Account{
		address addr;
		bool typee;//0 for user, 1 for org
	}
	Account [] accounts;
	constructor() public{
	}
	function getIndex(address _accountAddress) public returns(int256){
		for(uint256 i =0; i<accounts.length; i+=1)
		{
			if(accounts[i].addr == _accountAddress)
				return int256(i);
		}
		return -1;

	}
	function getType(uint index) public returns(bool){
		return accounts[index].typee;
	}
	function add(address _accAddress, bool _type) public{
		Account memory acc = Account(_accAddress, _type);
		accounts.push(acc);
	}
}