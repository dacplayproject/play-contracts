pragma solidity ^0.4.13;

import "ds-test/test.sol";

import "./MigrateController.sol";

contract MirateControllerTest is DSTest {
    MigrateController controller;
    PLS pls;

    function setUp() {
        pls = new PLS();
        controller = new MigrateController(pls);
    }

    function testFail_basic_sanity() {
        assertTrue(false);
    }

    function test_basic_sanity() {
        assertTrue(true);
    }
}
