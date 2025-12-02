#include <print>
#include <unordered_set>
#include "tools.h"

constexpr size_t ROWS = 50;
constexpr size_t COLS = 50;

using aai = std::array<std::array<int, ROWS>, COLS>;
using spi = std::unordered_set<pi, pair_hash>;

auto parseFile() -> aai {
  std::ifstream file("input/day10.txt");
  assert(file);
  std::string line;

  aai arr = {{{0}}};

  int r_ind = 0;
  while (std::getline(file, line)) {
    for (size_t c_ind = 0; c_ind < line.size(); c_ind++) {
      arr[r_ind][c_ind] = line[c_ind] - '0';
    }
    r_ind++;
  }

  return arr;
}

auto bfs(const aai &mat, pi pos, spi &visited, int target) -> size_t {
  spi l_visited;
  std::vector<pi> queue;
  size_t ttl = 0;

  queue.emplace_back(pos);
  l_visited.insert(pos);

  while (queue.size() > 0) {
    pi current = queue.back();
    queue.pop_back();
    if (arrValue(std::span(mat), current) == target) ttl++;

    auto n = nbrs(std::span(mat), current, Direction::Udlr);
    for (size_t ind{0}; ind < n.indices.size(); ind++) {
      auto val = n.indices[ind];
      if ((n.vals[ind] == arrValue(std::span(mat), current) + 1) &&
          !l_visited.contains(val)) {
        queue.emplace_back(val);
        l_visited.insert(val);
        visited.insert(val);
      }
    }
  }

  return ttl;
}

auto dfs(const aai &mat, pi pos, spi &visited, int target) -> size_t {
  size_t ttl = 0;
  if (arrValue(std::span(mat), pos) == target) return 1;

  visited.insert(pos);
  auto nbr = nbrs(std::span(mat), pos, Direction::Udlr);
  for (const auto &n : nbr.indices) {
    if (!visited.contains(n) &&
        arrValue(std::span(mat), n) == arrValue(std::span(mat), pos) + 1) {
      ttl += dfs(mat, n, visited, 9);
    }
    visited.erase(pos);
  }

  return ttl;
}

auto solution(const aai &mat) -> void {
  size_t pt1{0}, pt2{0};
  spi pt1_visited;
  spi pt2_visited;

  int r_ind = 0;
  for (const auto &r_val : mat) {
    int c_ind = 0;
    for (const auto &c_val : r_val) {
      if (c_val == 0) {
        auto tmp = std::make_pair(r_ind, c_ind);
        if (!pt1_visited.contains(tmp)) {
          pt1 += bfs(mat, tmp, pt1_visited, 9);
        }
        pt2 += dfs(mat, tmp, pt2_visited, 9);
      }
      c_ind++;
    }
    r_ind++;
  }

  std::print("Part 1: {}\nPart 2: {}", pt1, pt2);
}

auto main() -> int {
  auto arr = parseFile();
  solution(arr);
}
