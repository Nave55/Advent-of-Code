#include "sl/containers/hash_set.hpp"
#include "sl/tools/cstring_tools.hpp"

Arena arena_alloc(1 * MB);

template <typename P = Pair<Vec<int>, Vec<int>>>
void parseFile(const char* path, const char* delim, P& parse) {
  FILE* file = fopen(path, "r");
  if (file == NULL) perror("Error opening file");

  char line[32];
  while (fgets(line, sizeof(line), file) != NULL) {
    auto [left, right] = splitOnce(line, delim);
    parse.x.pushBack(atoi(left));
    parse.y.pushBack(atoi(right));
  }

  fclose(file);
}

int main() {
  Pair pair(Vec<int>(1000), Vec<int>(1000));
  parseFile("input/day1.txt", "   ", pair);

  pair.x.sort();
  pair.y.sort();

  int sum1 = 0, sum2 = 0;
  HashSet<int> map(arena_alloc, 1000, 1, 2048);
  for (auto i : pair.x) map.insert(i);

  for (size_t i = 0; i < pair.x.len; i++) {
    int left = pair.x[i], right = pair.y[i];
    sum1 += abs(left - right);
    if (map.contains(right)) sum2 += right;
  }

  std::printf("Part 1: %d\nPart 2: %d\n", sum1, sum2);
}
