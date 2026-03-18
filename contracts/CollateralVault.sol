// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract CollateralVault {
    AggregatorV3Interface internal priceFeed;

    mapping(address => uint256) public collateral;
    mapping(address => bool) public isCollateralized;

    constructor(address _priceFeed) {
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    function depositCollateral() public payable {
        require(msg.value > 0, "Must send ETH to deposit");
        collateral[msg.sender] += msg.value;
        isCollateralized[msg.sender] = true;
    }

    function withdrawCollateral(uint256 amount) public {
        require(collateral[msg.sender] >= amount, "Insufficient collateral");
        collateral[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
        if (collateral[msg.sender] == 0) {
            isCollateralized[msg.sender] = false;
        }
    }

    function getLatestPrice() public view returns (int) {
        ( , int price, , , ) = priceFeed.latestRoundData();
        return price;
    }
}