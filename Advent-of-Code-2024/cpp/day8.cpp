#include <cassert>
#include <format>
#include <fstream>
#include <iostream>
#include <unordered_map>
#include <unordered_set>
#include "tools.h"

constexpr int ROWS = 50;
constexpr int COLS = 50;

using pi = std::pair<int, int>;
using Mat = std::array<std::array<char, COLS>, ROWS>;
using Ants = std::unordered_map<char, std::vector<pi>>;
using Slopes = std::unordered_map<pi, std::vector<pi>, pair_hash>;
using Spi = std::unordered_set<pi, pair_hash>;

struct ParseFile {
  Mat mat;
  Ants ants;
};

auto parseFile() -> ParseFile;
auto antSlopes(const Ants &ants) -> Slopes;
auto solution(const Mat &arr, const Slopes &slopes) -> size_t;
auto solution2(const Slopes &slopes) -> size_t;

auto main() -> int {
  auto [mat, ants] = parseFile();
  auto slopes = antSlopes(ants);
  auto sol1 = solution(mat, slopes);
  auto sol2 = solution2(slopes);

  std::cout << std::format("Part 1: {}\nPart 2: {}", sol1, sol2) << "\n";
}

auto parseFile() -> ParseFile {
  Mat arr{{'.'}};
  Ants mp{{}};

  std::ifstream file("input/day8.txt");
  assert(file);
  std::string line;

  size_t r_ind{0};
  while (std::getline(file, line)) {
    for (size_t c_ind{0}; c_ind < line.size(); ++c_ind) {
      arr[r_ind][c_ind] = line[c_ind];
      if (mp.count(line[c_ind]) == 0) mp[line[c_ind]] = {};
      if (line[c_ind] != '.')
        mp[(char) line[c_ind]].emplace_back((int) r_ind, (int) c_ind);
    }
    ++r_ind;
  }

  return {arr, mp};
}

auto antSlopes(const Ants &ants) -> Slopes {
  Slopes slopes{};

  for (const auto &vals : ants) {
    if (vals.second.size() < 2) continue;

    for (size_t i{0}; i < vals.second.size() - 1; ++i) {
      for (size_t j{i + 1}; j < vals.second.size(); ++j) {
        slopes[vals.second[i]].emplace_back(vals.second[i] - vals.second[j]);
      }
    }
  }

  return slopes;
}

auto solution(const Mat &mat, const Slopes &slopes) -> size_t {
  Spi sol1{};

  auto insertSet = [&](const pi &pos, const Mat &mat, char symb,
                       Spi &set) -> void {
    if (inBounds(pos, ROWS, COLS) && arrValue(std::span(mat), pos) != symb) {
      set.emplace(pos);
    }
  };

  for (const auto &vals : slopes) {
    for (const auto &i : vals.second) {
      auto vec = vals.first;
      auto symb = mat[vec.first][vec.second];
      auto pos = i + vals.first;
      auto neg = vec - (i * 2);

      insertSet(pos, mat, symb, sol1);
      insertSet(neg, mat, symb, sol1);
    }
  }

  return sol1.size();
}

auto solution2(const Slopes &slopes) -> size_t {
  Spi sol2{};

  auto walk = [&](pi &pos, const pi &step, Spi &set) -> void {
    while (true) {
      pos = pos + step;
      if (inBounds(pos, ROWS, COLS)) {
        set.emplace(pos);
      } else
        break;
    }
  };

  for (const auto &vals : slopes) {
    auto key = vals.first;
    auto value = vals.second;
    sol2.emplace(key);

    for (const auto &i : value) {
      auto val = key;
      walk(val, i, sol2);
      walk(val, {-i.first, -i.second}, sol2);
    }
  }

  return sol2.size();
}
