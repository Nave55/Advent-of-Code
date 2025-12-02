#include <print>
#include "tools.h"

auto checkSafety(std::span<int> arr) -> bool {
  if (arr.size() <= 1) return true;

  bool is_inc = true, is_dec = true;
  for (size_t i = 0; i < arr.size() - 1; i++) {
    if (!is_inc && !is_dec) return false;
    int val = arr[i] - arr[i + 1];
    if (is_inc) is_inc = val >= 1 && val <= 3;
    if (is_dec) is_dec = val <= -1 && val >= -3;
  }

  return is_inc || is_dec;
}

auto checkSafetyTwo(std::span<int> arr) -> bool {
  if (checkSafety(arr)) return true;

  for (size_t i = 0; i < arr.size(); i++) {
    vi tmp(arr.begin(), arr.end());
    tmp.erase(tmp.begin() + i);
    if (checkSafety(tmp)) return true;
  }

  return false;
}

auto solution(const char* path) -> void {
  std::ifstream file(path);
  assert(file);
  std::string line;

  int ttl1 = 0, ttl2 = 0;
  while (std::getline(file, line)) {
    auto vec = line | std::views::split(' ') |
               std::views::transform([](auto&& subrange) {
                 int value = 0;
                 std::string_view sv(subrange.begin(), subrange.end());
                 std::from_chars(sv.data(), sv.data() + sv.size(), value);
                 return value;
               }) |
               std::ranges::to<vi>();

    if (checkSafety(vec)) ttl1++;
    if (checkSafetyTwo(vec)) ttl2++;
  }

  std::print("Part 1: {}\nPart 2: {}", ttl1, ttl2);
}

auto main() -> int {
  solution("input/day2.txt");
}
