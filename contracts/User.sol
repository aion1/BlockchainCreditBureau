pragma solidity >=0.4.21 <0.7.0;

contract User {
  //Loan loan;
  address public userAddress;
  bytes32 userName;
  address [] array;
  //creator TokenCreator(msg.sender);
  constructor() public {
    userAddress = msg.sender;
  }
  function confirmLoan () internal returns(bool res)  
  {
    return true;
  }

  function changeName(bytes32 _newName) public {
    // Only the creator can alter the name --
    // the comparison is possible since contracts
    // are implicitly convertible to addresses.
    if (msg.sender == userAddress)
        userName = _newName;
  }

  function push(address _text) external {
      array.push(_text);
  }

  function get() external view returns(address[] memory) {
    return array;
  }

  function view_user () internal returns(bool res)  {
    
  }
    
}