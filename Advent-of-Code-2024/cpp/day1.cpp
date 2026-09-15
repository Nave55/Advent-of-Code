#include "mem/allocators.hpp"
#include "containers/hash_map.hpp"
#include "containers/vec.hpp"
#include "tools.h"

Arena arena_alloc(1 * MB);

template <typename Parse = std::pair<Vec<int>, Vec<int>>>
void parseFile(const char* path, const char* delim, Parse& parse) {
  FILE* file = fopen(path, "r");
  if (file == NULL) perror("Error opening file");

  char line[32];
  while (fgets(line, sizeof(line), file) != NULL) {
    auto [left, right] = splitOnce(line, delim);
    parse.first.pushBack(atoi(left));
    parse.second.pushBack(atoi(right));
  }

  fclose(file);
}

int main() {
  std::pair pair = {Vec<int>(1000), Vec<int>(1000)};
  parseFile("day1.txt", "   ", pair);

  pair.first.sort();
  pair.second.sort();

  int sum1 = 0, sum2 = 0;
  HashMap<int, int> map(arena_alloc, 64, 16);
  for (auto i : pair.first) map.insert(i, 0);

  for (size_t i = 0; i < pair.first.len; i++) {
    int left = pair.first[i], right = pair.second[i];
    sum1 += abs(left - right);
    if (map.contains(right)) sum2 += right;
  }

  std::printf("Part 1: %d\nPart 2: %d\n", sum1, sum2);
}
