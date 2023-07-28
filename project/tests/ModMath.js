const ModMath = artifacts.require("ModMathUser");

const PRIMES = [3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47];

contract("ModMath", () => {
    let modMath;

    before(async () => {
        modMath = await ModMath.new();
    });

    for (const p of PRIMES) {
        for (const q of PRIMES) {
            if (p < q) {
                const modulus = (p - 1) * (q - 1);
                for (let start = 1; start < modulus; start += 2) {
                    it(`findInverse(${p}, ${q}, ${start})`, async () => {
                        const {e, d} = await modMath.findInverse(p, q, start);
                        assert(e * d % modulus == 1, `${e}, ${d}`);
                    });
                }
            }
        }
    }

    for (const p of PRIMES.filter(n => n % 4 == 3)) {
        for (const q of PRIMES.filter(n => n % 4 == 3)) {
            if (p < q) {
                const modulus = p * q;
                for (let start = 1; start < modulus; start += 1) {
                    it(`findSquare(${p}, ${q}, ${start})`, async () => {
                        const {s, r1, r2, r3, r4} = await modMath.findSquare(p, q, start);
                        for (const r of [r1, r2, r3, r4]) {
                            assert(s == r * r % modulus, `${s}, ${r}`);
                        }
                    });
                }
            }
        }
    }
});
