pragma solidity >=0.4.21 <0.7.0;

contract Accounts{
	struct Account{
		address add;
		bool typee;//0 for user, 1 for org
	}
	Account [] accounts;
}