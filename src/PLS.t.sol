pragma solidity ^0.4.17;

import "ds-test/test.sol";

import "./PLS.sol";

contract PLSTest is DSTest {
    PLS pls;

    function setUp() {
        pls = new PLS();
    }

    function testFail_basic_sanity() {
        assertTrue(false);
    }

    function test_basic_sanity() {
        assertTrue(true);
    }
}