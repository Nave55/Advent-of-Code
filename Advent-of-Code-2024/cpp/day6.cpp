#include <cassert>
#include <fstream>
#include <unordered_map>
#include <unordered_set>
#include "tools.h"

typedef std::pair<int, int> pi;
typedef std::unordered_map<pi, int, pair_hash> mpi;
typedef std::unordered_set<pi, pair_hash> spi;

struct ParseFile {
  mpi locs;
  pi start;
};

constexpr int ROWS = 130;
constexpr int COLS = 130;
char mat[ROWS][COLS]{{'.'}};
const pi dirs[4]{{-1, 0}, {0, 1}, {1, 0}, {0, -1}};

auto parseFile() -> ParseFile {
  mpi locs;
  pi start;

  std::ifstream file("input/day6.txt");
  assert(file);
  std::string line;

  size_t i{0};
  while (std::getline(file, line)) {
    for (size_t j{0}; j < ROWS; ++j) {
      if (line[j] == '#' || line[j] == '^') mat[i][j] = line[j];
      auto pair = std::make_pair(i, j);
      if (line[j] == '^') start = pair;
      if (line[j] == '#') locs[pair] = 0;
    }

    ++i;
  }

  return {locs, start};
}

auto inbounds(const pi &pos) -> bool {
  return ((pos.first > 0 && pos.first < ROWS - 1) &&
          (pos.second > 0 && pos.second < COLS - 1));
}

auto solution(pi pos) -> spi {
  auto facing = 0;
  spi visited;

  while (inbounds(pos)) {
    auto n_pos = dirs[facing] + pos;
    if (mat[n_pos.first][n_pos.second] == '#') {
      facing++;
      facing = facing % 4;
    } else {
      visited.emplace(pos);
      pos = n_pos;
    }
  }
  visited.emplace(pos);

  return visited;
}

auto solution2(const pi &start, const mpi &loc, const spi &empty) -> int {
  auto ttl = 0;
  auto locs = loc;

  for (auto &i : empty) {
    auto facing = 0;
    auto pos = start;
    mat[i.first][i.second] = '#';
    locs[i] = 0;

    while (inbounds(pos)) {
      auto n_pos = dirs[facing] + pos;
      if (arrValue(mat, n_pos) == '#') {
        facing++;
        locs[n_pos]++;
        if (locs[n_pos] == 4) {
          // std::cout << "Obstacle was at pos " << i << "\n";
          ttl++;
          break;
        }
        facing = facing % 4;
      } else
        pos = n_pos;
    }
    mat[i.first][i.second] = '.';
    locs = loc;
  }
  return ttl;
}

auto main() -> int {
  auto [locs, start] = parseFile();

  auto pt1 = solution(start);
  auto pt2 = solution2(start, locs, pt1);
  printf("Part 1: %d\nPart 2: %d\n", (int) pt1.size(), pt2);
}
