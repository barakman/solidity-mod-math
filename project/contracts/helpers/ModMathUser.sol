// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.28;

import "../ModMath.sol";

contract ModMathUser {
    function findInverse(uint256 p, uint256 q, uint256 start) external pure returns (Inverse memory) {
        return ModMath.findInverse(p, q, start);
    }

    function findSquare(uint256 p, uint256 q, uint256 start) external pure returns (Square memory) {
        return ModMath.findSquare(p, q, start);
    }
}
