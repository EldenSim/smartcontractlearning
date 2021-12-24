pragma solidity ^0.8.4;

contract Coin {
    // "Public" makes variable accessible from other contracts
    address public minter;
    mapping(address => uint256) public balances;

    // Events allows clients to react to specific contract changes you declare
    event Sent(address from, address to, uint256 amount);

    // constructor code is only run when the contract is created
    constructor() {
        minter = msg.sender;
    }

    // Sends an amount of newly created coins to an address
    // can only be called by the contract creator
    function mint(address receiver, uint256 amount) public {
        require(msg.sender == minter);
        balances[receiver] += amount;
    }

    //Errors allow you to provide information about why an operation failed
    // They are returned to the caller of the functon
    error InsufficientBalance(uint256 requested, uint256 available);

    //Sends an amount of existing coins from any caller to an address
    function send(address receiver, uint256 amount) public {
        if (amount > balances[msg.sender])
            revert InsufficientBalance({
                requested: amount,
                available: balances[msg.sender]
            });
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
}
