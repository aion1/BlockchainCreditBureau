pragma solidity >=0.4.21 <0.7.0;

contract Accounts{
	struct Account{
		address addr;
		bool typee;//0 for user, 1 for org
		uint256 points; // 0 for init and 0 for any organization
		uint256 optimalPoints; // 0 for init user and always 0 for organization
	}
	Account []  accounts;
	constructor() public{
		
	}
	function getIndex(address _accountAddress) public returns(int256){
		for(uint256 i = 0; i<accounts.length; i += 1)
		{
			if(accounts[i].addr == _accountAddress)
				return int256(i);
		}
		return -1;

	}
	function getType(uint index) public returns(bool){
		return accounts[index].typee;
	}
	function add(address _accAddress, bool _type) public returns(bool){
		if (!accountExists(_accAddress)){
			Account memory acc = Account(_accAddress, _type,0,0);
			accounts.push(acc);
			return true;
		}
		return false;

	}
	function accountExists(address _accAddress) internal returns(bool){
		if (getIndex(_accAddress) == -1)
			return false;
		return true;
	} 

	function deleteAccount(address _accAddress)public returns(bool){
		int256 myIndex=getIndex(_accAddress);
		if(myIndex != -1)
		{
			delete accounts[uint256(myIndex)];
			return true;
		}
		return false;		
	}
	function changePoints (address _loanie,uint256 _points)public returns(bool res)
	{
		int256 myIndex=getIndex(_loanie);
		if(myIndex != -1)
		{
			accounts[uint256(myIndex)].points+=_points;
			accounts[uint256(myIndex)].optimalPoints+=5;
			return true;
		}
		return false;
	}
	
}