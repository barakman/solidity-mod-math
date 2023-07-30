// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.21;

struct Inverse {
    uint256 e;
    uint256 d;
}

struct Square {
    uint256 s;
    uint256 r1;
    uint256 r2;
    uint256 r3;
    uint256 r4;
}

library ModMath {
    /// @param p an odd prime
    /// @param q an odd prime
    /// @param start an odd integer smaller than `(p - 1) * (q - 1)` to start the search from
    /// @return result a pair of inverses in the multiplicative group of integers modulo `(p - 1) * (q - 1)`
    function findInverse(uint256 p, uint256 q, uint256 start) internal pure returns (Inverse memory result) { unchecked {
        uint256 modulus = _mul(p - 1, q - 1);
        for (uint256 e = start; e < modulus; e += 2) {
            if (_gcd(modulus, e) == 1) {
                result.d = _inverse(modulus, e);
                result.e = e;
                break;
            }
        }
    }}

    /// @param p a prime which is congruent to 3 modulo 4
    /// @param q a prime which is congruent to 3 modulo 4
    /// @param start an integer smaller than `p * q` to start the search from
    /// @return result a square and its 4 roots in the multiplicative group of integers modulo `p * q`
    function findSquare(uint256 p, uint256 q, uint256 start) internal pure returns (Square memory result) { unchecked {
        uint256 modulus = _mul(p, q);
        uint256 pDivTwo = p / 2;
        uint256 qDivTwo = q / 2;
        for (uint256 s = start; s < modulus; s += 1) {
            if (_gcd(modulus, s) == 1 && _powmod(s, pDivTwo, p) == 1 && _powmod(s, qDivTwo, q) == 1) {
                uint256 sp = _powmod(s, p / 4 + 1, p);
                uint256 sq = _powmod(s, q / 4 + 1, q);
                uint256 tp = _mul(_inverse(p, q), q);
                uint256 tq = _mul(_inverse(q, p), p);
                uint256 up = _mul(0 + sp, tp);
                uint256 uq = _mul(0 + sq, tq);
                uint256 vp = _mul(p - sp, tp);
                uint256 vq = _mul(q - sq, tq);
                result.r1 = addmod(up, uq, modulus);
                result.r2 = addmod(up, vq, modulus);
                result.r3 = addmod(vp, uq, modulus);
                result.r4 = addmod(vp, vq, modulus);
                result.s = s;
                break;
            }
        }
    }}

    function _mul(uint256 a, uint256 b) private pure returns (uint256) {
        return a * b;
    }

    function _gcd(uint256 a, uint256 b) private pure returns (uint256) { unchecked {
        uint256 c = a % b;
        while (c > 0) {
            a = b;
            b = c;
            c = a % b;
        }
        return b;
    }}

    function _powmod(uint256 x, uint256 e, uint256 n) private pure returns (uint256) { unchecked {
        uint256 y = 1;
        while (e > 0) {
            if ((e & 1) == 1)
                y = mulmod(y, x, n);
            x = mulmod(x, x, n);
            e >>= 1;
        }
        return y;
    }}

    function _inverse(uint256 n, uint256 x) private pure returns (uint256) { unchecked {
        uint256 y1 = 0;
        uint256 y2 = 1;
        uint256 r1 = n;
        uint256 r2 = x;
        while (r2 != 0) {
            uint256 t1 = r1 / r2;
            uint256 t2 = addmod(y1, (n - mulmod(t1, y2, n)), n);
            (y1, y2) = (y2, t2);
            (r1, r2) = (r2, r1 - t1 * r2);
        }
        return y1;
    }}
}
