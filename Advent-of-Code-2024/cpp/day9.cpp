#include <cassert>
#include <fstream>
#include <print>
#include "tools.h"

struct FileInfo {
  int val;
  int pos;
  int size;
};

using vfi = std::vector<FileInfo>;

struct ParseFile {
  vi arr;
  vfi filled;
  vfi empty;
};

auto parseFile() -> ParseFile {
  std::ifstream file("input/day9.txt");
  assert(file);
  std::string line;
  file >> line;

  vi arr;
  vfi filled, empty;

  int f_val = 0, idx = 0;
  for (size_t ind = 0; ind < line.size(); ind++) {
    int times = line[ind] - '0';
    if (ind % 2 == 0) {
      for (int _ = 0; _ < times; _++) arr.push_back(f_val);
      if (times > 0) {
        filled.emplace_back(FileInfo{f_val, idx, times});
        f_val++;
      }
    } else {
      for (int _ = 0; _ < times; _++) arr.push_back(-1);
      if (times > 0) empty.emplace_back(FileInfo{-1, idx, times});
    }
    idx += times;
  }

  return {arr, filled, empty};
}

auto solution(vi &arr) -> uint64_t {
  size_t j = arr.size() - 1;
  uint64_t ttl = 0;
  for (size_t i = 0; i < arr.size(); i++) {
    if (arr[i] == -1) {
      while (j > i && arr[j] < 0) j--;
      if (j <= i) break;
      arr[i] = arr[j];
      arr[j] = -1;
    }
    if (arr[i] >= 0) ttl += i * arr[i];
  }

  return ttl;
}

auto solution2(vfi &filled, vfi &empty) -> uint64_t {
  uint64_t ttl = 0;
  for (int i = (int) filled.size() - 1; i >= 0; i--) {
    for (size_t j = 0; j < empty.size(); j++) {
      if (filled[i].pos <= empty[j].pos) break;
      if (filled[i].size <= empty[j].size) {
        filled[i].pos = empty[j].pos;
        empty[j].size -= filled[i].size;
        empty[j].pos += filled[i].size;
        break;
      }
    }
  }

  for (const auto &i : filled) {
    for (int ind = i.pos; ind < i.pos + i.size; ind++) {
      ttl += ind * i.val;
    }
  }

  return ttl;
}

auto main() -> int {
  auto [arr, filled, empty] = parseFile();
  auto pt1 = solution(arr);
  auto pt2 = solution2(filled, empty);
  std::print("Part 1: {}\nPart 2: {}\n", pt1, pt2);
}
