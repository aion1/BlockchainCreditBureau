pragma solidity >=0.4.21 <0.7.0;

contract User {
  Loan loan;
  address public userAddress;
  bytes32 userName;
  address [] array;
  creator = TokenCreator(msg.sender);
  constructor(bytes32 _userName) public {
    userAddress = msg.sender;`
  }
function Confirm_loan () returns(bool res) internal 
{
  return true;
}

function changeName(bytes32 _newName) public {
        // Only the creator can alter the name --
        // the comparison is possible since contracts
        // are implicitly convertible to addresses.
        if (msg.sender == userAddress)
            userName = newName;
    }

    function push(string calldata _text) external {
        array.push(_text);
    }

    function get() external view returns(string[] memory) {
        return array;
    }

    function view_user () returns(bool res) internal {
      
    }
    
  }