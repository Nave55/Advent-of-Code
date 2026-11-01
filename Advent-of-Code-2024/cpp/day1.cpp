#include "sl/containers/fixed_vector.hpp"
#include "sl/containers/hash_set.hpp"
#include "sl/tools/cstring_tools.hpp"

using Pii = Pair<Fixed_Vector<int, 1000>, Fixed_Vector<int, 1000>>;
Arena_Allocator arena_alloc;

void parseFile(const char* path, const char* delim, Pii& pair) {
  FILE* file = fopen(path, "r");
  if (file == NULL) perror("Error opening file");

  char line[32];
  while (fgets(line, sizeof(line), file) != NULL) {
    auto [left, right] = splitOnce(line, delim, arena_alloc);
    pair.x.pushBack(atoi(left));
    pair.y.pushBack(atoi(right));
  }

  fclose(file);
}

int main() {
  Pii pair;
  parseFile("input/day1.txt", "   ", pair);

  pair.x.sort();
  pair.y.sort();

  int sum1 = 0, sum2 = 0;
  Hash_Set<int> set(1000, 1, 2048, arena_alloc);
  for (auto i : pair.x) set.insert(i);

  for (size_t i = 0; i < pair.x.len; i++) {
    int left = pair.x[i], right = pair.y[i];
    sum1 += abs(left - right);
    if (set.contains(right)) sum2 += right;
  }

  std::printf("Part 1: %d\nPart 2: %d\n", sum1, sum2);
}
