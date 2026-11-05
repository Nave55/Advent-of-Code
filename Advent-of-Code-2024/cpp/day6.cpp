#include "sl/containers/hash_map.hpp"
#include "sl/containers/hash_set.hpp"
#include "sl/containers/vec.hpp"

Arena_Allocator arena_allocator;

struct PairHash {
  std::size_t operator()(const Vec2<int>& p) const noexcept {
    std::size_t h1 = std::hash<int>{}(p.x);
    std::size_t h2 = std::hash<int>{}(p.y);
    return h1 ^ (h2 + 0x9e3779b9 + (h1 << 6) + (h1 >> 2));
  }
};

using Pi = Vec2<int>;
using Mpi = Hash_Map<Pi, int, PairHash>;
using Spi = Hash_Set<Pi, PairHash>;

struct ParseFile {
  Mpi locs;
  Pi start;
};

#define ROWS 130
#define COLS 130
char mat[ROWS][COLS]{{'.'}};
constexpr Pi dirs[4]{{-1, 0}, {0, 1}, {1, 0}, {0, -1}};

ParseFile parseFile(const char* path) {
  Mpi locs(845, 1, 2048, arena_allocator);
  Pi start;

  FILE* file = fopen(path, "r");
  if (file == NULL) perror("Error opening file");

  int i = 0;
  char line[256];
  while (fgets(line, sizeof(line), file) != NULL) {
    for (int j = 0; j < ROWS; j++) {
      if (line[j] == '#' || line[j] == '^') mat[i][j] = line[j];
      Vec2<int> pair = {i, j};
      if (line[j] == '^') start = pair;
      if (line[j] == '#') locs.atOrInsert(pair);
    }
    i++;
  }

  return {locs, start};
}

bool inbounds(const Pi& pos) {
  return ((pos.x > 0 && pos.x < ROWS - 1) && (pos.y > 0 && pos.y < COLS - 1));
}

Spi solution(Pi pos) {
  size_t facing = 0;
  Spi visited(1050, 5, 8192, arena_allocator);

  while (inbounds(pos)) {
    Pi n_pos = dirs[facing] + pos;
    if (mat[n_pos.x][n_pos.y] == '#') {
      facing++;
      facing = facing % 4;
    } else {
      visited.insert(pos);
      pos = n_pos;
    }
  }
  visited.insert(pos);

  return visited;
}

size_t solution2(const Pi& start, const Spi& empty) {
  Mpi locs(200, 1, 1024, arena_allocator);
  size_t ttl = 0;

  for (auto& i : empty) {
    auto facing = 0;
    Pi pos = start;
    mat[i.x][i.y] = '#';

    while (inbounds(pos)) {
      Pi n_pos = dirs[facing] + pos;

      if (mat[n_pos.x][n_pos.y] == '#') {
        facing++;

        int count = locs.atOrInsert(n_pos)++;
        if (count == 4) {
          ttl++;
          break;
        }

        facing = facing % 4;
      } else {
        pos = n_pos;
      }
    }

    locs.clear();
    mat[i.x][i.y] = '.';
  }

  return ttl;
}

int main() {
  auto [locs, start] = parseFile("input/day6.txt");

  auto pt1 = solution(start);
  auto pt2 = solution2(start, pt1);
  printf("Part 1: %zu\nPart 2: %zu\n", pt1.size(), pt2);
}
