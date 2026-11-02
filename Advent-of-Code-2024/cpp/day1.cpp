#include "sl/containers/fixed_vector.hpp"
#include "sl/containers/hash_set.hpp"
#include "sl/tools/cstring_tools.hpp"

using Vec = Fixed_Vector<int, 1000>;
Arena_Allocator arena_alloc;

void parseFile(const char* path, const char* delim, Vec& left, Vec& right) {
  FILE* file = fopen(path, "r");
  if (file == NULL) perror("Error opening file");

  char line[32];
  while (fgets(line, sizeof(line), file) != NULL) {
    auto [l, r] = splitOnce(line, delim, arena_alloc);
    left.pushBack(atoi(l));
    right.pushBack(atoi(r));
  }

  fclose(file);
}

int main() {
  Vec left, right;
  parseFile("input/day1.txt", "   ", left, right);

  left.sort();
  right.sort();

  Hash_Set<int> set(1000, 1, 2048, arena_alloc);
  for (auto i : left) set.insert(i);

  int sum1 = 0, sum2 = 0;
  for (size_t i = 0; i < left.len; i++) {
    int l = left[i], r = right[i];
    sum1 += abs(l - r);
    if (set.contains(r)) sum2 += r;
  }

  std::printf("Part 1: %d\nPart 2: %d\n", sum1, sum2);
}
