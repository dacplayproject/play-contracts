pragma solidity ^0.4.23;

import "ds-stop/stop.sol";
import "erc20/erc20.sol";

contract PLS2RINGVendor is DSStop {
    ERC20 public PLS;
    ERC20 public RING;

    uint public gasRequired;

    constructor(address _pls, address _ring) public
    {
        PLS = ERC20(_pls);
        RING = ERC20(_ring);
    }

    function tokenFallback(address _from, uint256 _value, bytes _data) public
    {
        tokenFallback(_from, _value);
    }

    function tokenFallback(address _from, uint256 _value) public
    {
        if(msg.sender == address(PLS))
        {
            require(RING.transfer(_from, _value));

            TokenSwap(_from, _value);
        }
    }

    // @dev compatible backwards for PLS token contract
    function receiveToken(address _from, uint256 _amount, address _pls) public {
        if (msg.sender == PLS) {
            require(RING.transfer(_from, _amount));
            TokenSwap(_from, _amount);
        }
    }

    // TODO: Following logic check can be used by PLS's token controller onTransfer method to check the validation of the trx.
    function onTokenTransfer(address _from, address _to, uint _amount) public returns (bool)
    {
        if (_to == address(this))
        {
            if (msg.gas < gasRequired) return false;

            if (stopped) return false;

            if (RING.balanceOf(this) < _amount) return false;
        }

        return true;
    }

    function changeGasRequired(uint _gasRequired) public auth {
        gasRequired = _gasRequired;
        ChangeGasReuired(_gasRequired);
    }

    /// @notice This method can be used by the controller to extract mistakenly
    ///  sent tokens to this contract.
    /// @param _token The address of the token contract that you want to recover
    ///  set to 0 in case you want to extract ether.
    function claimTokens(address _token) public auth {
        if (_token == 0x0) {
            owner.transfer(this.balance);
            return;
        }
        
        ERC20 token = ERC20(_token);
        
        uint256 balance = token.balanceOf(this);
        
        token.transfer(owner, balance);
        ClaimedTokens(_token, owner, balance);
    }

    event TokenSwap(address indexed _from, uint256 _value);
    event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);

    event ChangeGasReuired(uint _gasRequired);
}