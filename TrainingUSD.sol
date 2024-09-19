// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TrainingUSDT {
    string public name = "Training USDT Token";
    string public symbol = "TUSDT";
    uint8 public decimals = 6; // USDT generally uses 6 decimals
    uint256 public totalSupply;
    uint256 public expirationDate;

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    address public usdtAddress; // Asli USDT wallet address ko yahan store karenge

    modifier onlyBeforeExpiration() {
        require(block.timestamp < expirationDate, "Token has expired");
        _;
    }

    constructor(uint256 _initialSupply, uint256 _expirationDays, address _usdtAddress) {
        totalSupply = _initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
        expirationDate = block.timestamp + (_expirationDays * 1 days);
        usdtAddress = _usdtAddress;  // Asli USDT wallet address ko assign karna
    }

    function transfer(address _to, uint256 _value) public onlyBeforeExpiration returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public onlyBeforeExpiration returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public onlyBeforeExpiration returns (bool success) {
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function checkOriginalUSDTBalance() public view returns (uint256) {
        // Placeholder function to simulate real USDT balance check
        // Actual implementation would involve interaction with the real USDT contract
        return balanceOf[usdtAddress];
    }
}
