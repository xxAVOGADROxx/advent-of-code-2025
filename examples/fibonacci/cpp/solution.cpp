// Fibonacci en C++. La stdlib no trae bigint, así que implementamos uno
// mínimo en base 10^9 — solo necesitamos suma para mantener paridad con
// Python/Rust/Haskell/TS, que sí tienen precisión arbitraria.
#include <cstddef>
#include <cstdint>
#include <iostream>
#include <iterator>
#include <string>
#include <vector>

namespace {

// Bigint little-endian en base 10^9: limbs[0] son los dígitos menos
// significativos. Soporta lo único que el demo usa: +=.
struct BigUInt {
  static constexpr uint32_t BASE = 1000000000;
  std::vector<uint32_t> limbs{0};

  BigUInt() = default;
  explicit BigUInt(uint32_t v) : limbs{v} {}

  BigUInt& operator+=(const BigUInt& o) {
    if (limbs.size() < o.limbs.size()) limbs.resize(o.limbs.size(), 0);
    uint64_t carry = 0;
    for (std::size_t i = 0; i < limbs.size(); ++i) {
      uint64_t sum = carry + limbs[i] + (i < o.limbs.size() ? o.limbs[i] : 0);
      limbs[i] = static_cast<uint32_t>(sum % BASE);
      carry = sum / BASE;
      // sin acarreo y fuera de los limbs de `o` nada más cambia
      if (!carry && i >= o.limbs.size()) break;
    }
    if (carry) limbs.push_back(static_cast<uint32_t>(carry));
    return *this;
  }

  std::string str() const {
    std::string out = std::to_string(limbs.back());
    for (std::size_t i = limbs.size() - 1; i-- > 0;) {
      std::string limb = std::to_string(limbs[i]);
      out += std::string(9 - limb.size(), '0') + limb;  // pad a 9 dígitos
    }
    return out;
  }
};

BigUInt operator+(BigUInt a, const BigUInt& b) {
  a += b;
  return a;
}

BigUInt fib(int n) {
  BigUInt a(0), b(1);
  for (int i = 0; i < n; ++i) {
    BigUInt next = a + b;
    a = b;
    b = next;
  }
  return a;
}

BigUInt fibSum(int n) {
  BigUInt total(0), a(0), b(1);
  for (int i = 0; i <= n; ++i) {
    total += a;
    BigUInt next = a + b;
    a = b;
    b = next;
  }
  return total;
}

}  // namespace

int main() {
  std::string raw((std::istreambuf_iterator<char>(std::cin)),
                  std::istreambuf_iterator<char>());
  int n = std::stoi(raw);
  std::cout << "Part 1: " << fib(n).str() << "\n"
            << "Part 2: " << fibSum(n).str() << "\n";
}
