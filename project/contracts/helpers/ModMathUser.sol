// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.21;

import "../ModMath.sol";

contract ModMathUser {
    function findInverse(uint128 p, uint128 q, uint128 start) external pure returns (Inverse memory) {
        return ModMath.findInverse(p, q, start);
    }

    function findSquare(uint128 p, uint128 q, uint128 start) external pure returns (Square memory) {
        return ModMath.findSquare(p, q, start);
    }
}
