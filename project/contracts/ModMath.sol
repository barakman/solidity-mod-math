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
    function findInverse(uint256 p, uint256 q, uint256 start) internal pure returns (Inverse memory) {
        uint256 modulus = (p - 1) * (q - 1);
        for (uint256 e = start; e < modulus; e += 2) {
            if (_gcd(modulus, e) == 1) {
                uint256 d = _inverse(modulus, e);
                return Inverse(e, d);
            }
        }
        return Inverse(0, 0);
    }

    /// @param p An odd prime
    /// @param q An odd prime
    /// @param start An integer smaller than `p * q` to start the search from
    /// @return A square and its 4 roots in the multiplicative group of integers modulo `p * q`
    function findSquare(uint256 p, uint256 q, uint256 start) internal pure returns (Square memory) {
        uint256 modulus = p * q;
        for (uint256 s = start; s < modulus; s += 1) {
            if (_gcd(modulus, s) == 1 && _inQR(s, p, q)) {
                uint256 sp = _powMod(s, (p + 1) / 4, p);
                uint256 sq = _powMod(s, (q + 1) / 4, q);
                uint256 r1 = _map(0 + sp, 0 + sq, p, q);
                uint256 r2 = _map(0 + sp, q - sq, p, q);
                uint256 r3 = _map(p - sp, 0 + sq, p, q);
                uint256 r4 = _map(p - sp, q - sq, p, q);
                return Square(s, r1, r2, r3, r4);
            }
        }
        return Square(0, 0, 0, 0, 0);
    }

    function _gcd(uint256 a, uint256 b) private pure returns (uint256) {
        uint256 c = a % b;
        while (c > 0) {
            a = b;
            b = c;
            c = a % b;
        }
        return b;
    }

    function _powMod(uint256 x, uint256 e, uint256 n) private pure returns (uint256) {
        uint256 y = 1;
        while (e > 0) {
            if ((e & 1) == 1)
                y = y * x % n;
            x = x * x % n;
            e >>= 1;
        }
        return y;
    }

    function _inQR(uint256 y, uint256 p) private pure returns (bool) {
        return _powMod(y, p / 2, p) == 1;
    }


    function _inQR(uint256 y, uint256 p, uint256 q) private pure returns (bool) {
        return _inQR(y, p) && _inQR(y, q);
    }

    function _map(uint256 u, uint256 v, uint256 p, uint256 q) private pure returns (uint256) {
        uint256 a = q * _inverse(p, q);
        uint256 b = p * _inverse(q, p);
        return (u * a + v * b) % (p * q);
    }

    function _inverse(uint256 n, uint256 a) private pure returns (uint256) {
        int256 x1 = 1;
        int256 x2 = 0;
        int256 y1 = 0;
        int256 y2 = 1;
        uint256 r1 = n;
        uint256 r2 = a;
        while (r2 != 0) {
            uint256 r3 = r1 % r2;
            uint256 q3 = r1 / r2;
            int256 x3 = x1 - x2 * int256(q3);
            int256 y3 = y1 - y2 * int256(q3);
            x1 = x2;
            x2 = x3;
            y1 = y2;
            y2 = y3;
            r1 = r2;
            r2 = r3;
        }
        return y1 >= 0 ? uint256(y1) : n - uint256(-y1);
    }
}
