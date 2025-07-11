// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SmartBNB is ERC20, Ownable {
    uint256 public immutable maxSupply;

    address public teamWallet;
    address public marketingWallet;
    address public reserveWallet;

    constructor() ERC20("Smart BNB", "SBNB") Ownable(msg.sender) {
        teamWallet = 0x7eC3A135920D6D334bf6EFa361693986CEB0C47f;
        marketingWallet = 0x14eBC6F16995b4daA7FBB6Fc33590Cb8B968362B;
        reserveWallet = 0xe1cFC8f8C4A9B9809A0E49310b0DBdDab8bA158B;

        uint256 _initialSupply = 21000000;
        maxSupply = _initialSupply * 10 ** decimals();

        _mint(msg.sender, (maxSupply * 60) / 100);        // 60% to deployer
        _mint(teamWallet, (maxSupply * 15) / 100);        // 15% to team
        _mint(marketingWallet, (maxSupply * 15) / 100);   // 15% to marketing
        _mint(reserveWallet, (maxSupply * 10) / 100);     // 10% to reserve
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount * 10 ** decimals());
    }

    function burnFrom(address account, uint256 amount) external {
        uint256 amt = amount * 10 ** decimals();
        _spendAllowance(account, msg.sender, amt);
        _burn(account, amt);
    }

    function mint(address to, uint256 amount) external onlyOwner {
        uint256 amt = amount * 10 ** decimals();
        require(totalSupply() + amt <= maxSupply, "Max supply exceeded");
        _mint(to, amt);
    }
}
