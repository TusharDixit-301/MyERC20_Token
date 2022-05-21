// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract My_ERC20{
    string token_name;
    string token_symbol;
    uint total_supply;
    address owner;
    uint max_supply_limit = 1*(10**6)*(10**18);

    mapping(address => uint) private _userBalance;
    mapping(address => mapping(address => uint)) allowance;

    event Transfer(address _from,address _to, uint _amount);
    event Approved(address _owner, address _spender, uint _amount);

    constructor(string memory _token_name, string memory _token_symbol){
        token_name = _token_name;
        token_symbol = _token_symbol;
        owner = msg.sender;
    }

    modifier onlyOwner{
        require(
            owner == msg.sender,
            "My_ERC20 : Only owner is authroize for this transaction"
        );
        _;
    }

    function TokenName() public view returns(string memory){
        return token_name;
    }

    function TokenSymbol() public view returns(string memory){
        return token_symbol;
    }

    function TotalSupply() public view returns(uint){
        return total_supply;
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _userBalance[account];
    }

    function allowances(address _owner, address _spender) public view returns (uint256) {
        return allowance[_owner][_spender];
    }


    function mint_Token(address _to,uint _amount) public onlyOwner {
        require(
            total_supply <= max_supply_limit,
            "My_ERC20 : Minting Limit exceeded"
        );
        _userBalance[_to] += _amount;
        total_supply += _amount;
        
        emit Transfer(address(0), _to, _amount);
    }

    function burn(address _account, uint _amount) public onlyOwner {
        require(
            _userBalance[msg.sender] >= _amount,
            "My_ERC20 : Insufficent Fund Requested To Burn"
        );
        _userBalance[_account] -= _amount;
        total_supply -= _amount;

        emit Transfer(_account, address(0), _amount);
    }

    function transfer(address _to, uint _amount) external {
        _transfer(msg.sender, _to, _amount);

        emit Transfer(msg.sender, _to, _amount);
    }

    function transferFrom(address _from, address _to, uint _amount) external{
        require(
            allowance[_from][msg.sender] >= _amount,
            "My_ERC20 : Not enough allowance"
        );
        _transfer(_from, _to, _amount);
        allowance[_from][msg.sender] -= _amount;

        emit Transfer(_from, _to, _amount);
    }

    function approve(address _spender, uint _amount) public{
        require(
            _spender != address(0),
            "My_ERC20 : Illegal Transfer to address(0)"
        );
        allowance[msg.sender][_spender] = _amount;

        emit Approved(msg.sender, _spender, _amount);
    }

    function _transfer(address _from, address _to, uint _amount) internal {
        require(
            _to != address(0) && _from != address(0),
            "My_ERC20 : Illegal Transfer to address(0)"
        );

        require(
             _userBalance[_from] >= _amount,
             "My_ERC20 : Insufficent amount transfer"
        );

        uint _fromBalance = _userBalance[_from];
        _userBalance[_from] = _fromBalance - _amount;
        _userBalance[_to] += _amount;
    }
}
