# Solidity Modular Arithmetic

## `ModMath` library implements the following functions:
- `function findInverse(uint256 p, uint256 q, uint256 start) => (Inverse memory)`
- `function findSquare(uint256 p, uint256 q, uint256 start) => (Square memory)`

## Function `findInverse`:
- Takes input `p`: an odd prime
- Takes input `q`: an odd prime
- Takes input `start`: an odd integer smaller than `(p - 1) * (q - 1)` to start the search from
- Returns a pair of inverses in the multiplicative group of integers modulo `(p - 1) * (q - 1)`

## Function `findSquare`:
- Takes input `p`: a prime which is congruent to 3 modulo 4
- Takes input `q`: a prime which is congruent to 3 modulo 4
- Takes input `start`: an integer smaller than `p * q` to start the search from
- Returns a square and its 4 roots in the multiplicative group of integers modulo `p * q`
