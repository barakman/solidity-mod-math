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
    /// @param p An odd prime
    /// @param q An odd prime
    /// @param start An odd integer smaller than `(p - 1) * (q - 1)` to start the search from
    /// @return A pair of inverses in the multiplicative group of integers modulo `(p - 1) * (q - 1)`
    function findInverse(uint256 p, uint256 q, uint256 start) internal pure returns (Inverse memory) { unchecked {
        uint256 modulus = _mul(p - 1, q - 1);
        for (uint256 e = start; e < modulus; e += 2) {
            if (_gcd(modulus, e) == 1) {
                uint256 d = _inverse(modulus, e);
                return Inverse(e, d);
            }
        }
        return Inverse(0, 0);
    }}

    /// @param p A prime which is congruent to 3 modulo 4
    /// @param q A prime which is congruent to 3 modulo 4
    /// @param start An integer smaller than `p * q` to start the search from
    /// @return A square and its 4 roots in the multiplicative group of integers modulo `p * q`
    function findSquare(uint256 p, uint256 q, uint256 start) internal pure returns (Square memory) { unchecked {
        uint256 modulus = _mul(p, q);
        uint256 pDiv4Ceil = p / 4 + 1;
        uint256 qDiv4Ceil = q / 4 + 1;
        uint256 qMulInvPQ = _mul(q, _inverse(p, q));
        uint256 pMulInvQP = _mul(p, _inverse(q, p));
        for (uint256 s = start; s < modulus; s += 1) {
            if (_gcd(modulus, s) == 1 && _powMod(s, p / 2, p) == 1 && _powMod(s, q / 2, q) == 1) {
                uint256 sp = _powMod(s, pDiv4Ceil, p);
                uint256 sq = _powMod(s, qDiv4Ceil, q);
                uint256 r1 = _mapped(qMulInvPQ, pMulInvQP, 0 + sp, 0 + sq, modulus);
                uint256 r2 = _mapped(qMulInvPQ, pMulInvQP, 0 + sp, q - sq, modulus);
                uint256 r3 = _mapped(qMulInvPQ, pMulInvQP, p - sp, 0 + sq, modulus);
                uint256 r4 = _mapped(qMulInvPQ, pMulInvQP, p - sp, q - sq, modulus);
                return Square(s, r1, r2, r3, r4);
            }
        }
        return Square(0, 0, 0, 0, 0);
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

    function _mapped(uint256 a, uint256 b, uint256 c, uint256 d, uint256 n) private pure returns (uint256) { unchecked {
        return addmod(_mul(a, c), _mul(b, d), n);
    }}

    function _powMod(uint256 x, uint256 e, uint256 n) private pure returns (uint256) { unchecked {
        uint256 y = 1;
        while (e > 0) {
            if ((e & 1) == 1)
                y = mulmod(y, x, n);
            x = mulmod(x, x, n);
            e >>= 1;
        }
        return y;
    }}

    function _inverse(uint256 n, uint256 a) private pure returns (uint256) { unchecked {
        uint256 y1 = 0;
        uint256 y2 = 1;
        uint256 r1 = n;
        uint256 r2 = a;
        while (r2 != 0) {
            uint256 t1 = r1 / r2;
            uint256 t2 = addmod(y1, (n - mulmod(t1, y2, n)), n);
            (y1, y2) = (y2, t2);
            (r1, r2) = (r2, r1 - t1 * r2);
        }
        return y1;
    }}
}
