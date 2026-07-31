// AoC 2025 — template C++. Lee stdin, imprime Part 1 y Part 2.
#include <cstddef>
#include <iostream>
#include <iterator>
#include <string>
#include <vector>

namespace {

std::vector<std::string> parse(const std::string& raw) {
  std::vector<std::string> lines;
  std::size_t start = 0;
  while (start < raw.size()) {
    std::size_t end = raw.find('\n', start);
    if (end == std::string::npos) {
      lines.push_back(raw.substr(start));
      break;
    }
    lines.push_back(raw.substr(start, end - start));
    start = end + 1;
  }
  return lines;
}

std::string part1(const std::vector<std::string>& /*data*/) { return "TODO"; }

std::string part2(const std::vector<std::string>& /*data*/) { return "TODO"; }

}  // namespace

int main() {
  std::string raw((std::istreambuf_iterator<char>(std::cin)),
                  std::istreambuf_iterator<char>());
  std::vector<std::string> data = parse(raw);
  std::cout << "Part 1: " << part1(data) << "\n"
            << "Part 2: " << part2(data) << "\n";
}
