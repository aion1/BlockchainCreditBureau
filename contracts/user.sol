pragma solidity >=0.4.21 <0.7.0;

contract User {
  Loan loan;
  address public user_address;
  bytes32 user_name;
  address [] array;
  creator = TokenCreator(msg.sender);
  constructor(bytes32 user_name) public {
    user_address = msg.sender;`
  }
function Confirm_loan () returns(bool res) internal 
{
  return true;
}

function changeName(bytes32 newName) public {
        // Only the creator can alter the name --
        // the comparison is possible since contracts
        // are implicitly convertible to addresses.
        if (msg.sender == user_address)
            name = newName;
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