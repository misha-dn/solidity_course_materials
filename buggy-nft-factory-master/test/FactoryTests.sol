// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {NFTFactory} from "../src/NFTFactory.sol";
import {BuggyNFT} from "../src/BuggyNFT.sol";

contract FactoryTest is Test {

    NFTFactory factory;
    BuggyNFT nftImplementation;

    function setUp() public {
        nftImplementation = new BuggyNFT();
        factory = new NFTFactory(address(nftImplementation));
    }

    function testDeploy() public {
        bytes memory initializer = abi.encodeWithSignature("initialize(string,string)", "TEST", "TST");

        factory.deployNFT(initializer);
    }

}
