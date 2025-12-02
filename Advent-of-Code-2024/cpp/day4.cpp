#include <cassert>
#include <ranges>
#include <utility>
#include "tools.h"

std::array<pi, 24> dirs = {
    {{-3, -3}, {-2, -2}, {-1, -1}, {-3, 3}, {-2, 2}, {-1, 1}, {3, -3}, {2, -2},
     {1, -1},  {3, 3},   {2, 2},   {1, 1},  {-3, 0}, {-2, 0}, {-1, 0}, {3, 0},
     {2, 0},   {1, 0},   {0, -3},  {0, -2}, {0, -1}, {0, 3},  {0, 2},  {0, 1}}};

auto checkXmas(const vvc &mat) -> int {
  auto width = (int)mat[0].size();
  auto height = (int)mat.size();
  int ttl = 0;

  for (int i = 0; i < height; i++) {
    for (int j = 0; j < width; j++) {
      if (mat[i][j] != 'X') continue;
      std::string str;
      int cnt = 0; 
      for (const auto &val : dirs) {
        cnt++;
        auto tmp = val + std::make_pair(i, j);
        if (tmp.first >= 0 && tmp.first < height && tmp.second >= 0 &&
            tmp.second < width) {
          str += mat[tmp.first][tmp.second];
        }
        if (cnt % 3 == 0) {
          str += "X";
          if (str == "XMAS" || str == "SAMX") ttl++;
          str = "";
        }
      }
    }
  }

  return ttl;
}

auto checkX(const vvc &mat) -> int {
  int ttl = 0;
  for (size_t i = 0; i < mat.size(); i++) {
    for (size_t j = 0; j < mat[0].size(); j++) {
      if (mat[i][j] != 'A') continue;
      auto n = nbrs<char, 4>(mat, {i, j}, Direction::Diags);
      // if (n.size != 4) continue;
      auto tmp = tJoin(n.vals);
      if (tmp == "MMSS" || tmp == "SSMM" || tmp == "SMSM" || tmp == "MSMS")
        ttl++;
    }
  }

  return ttl;
}

auto solution() -> void {
  std::ifstream file("input/day4.txt");
  assert(file);
  std::string line;
  vvc arr;

  while (std::getline(file, line)) arr.emplace_back(std::ranges::to<vc>(line));
  printf("Part 1: %d\nPart 2: %d\n", checkXmas(arr), checkX(arr));
}

auto main() -> int {
  solution();
}
