#include <algorithm>
#include <cassert>
#include <fstream>
#include <iostream>
#include <ranges>
#include <set>
#include <string>
#include <vector>
#include "tools.h"

struct Directory {
  std::string path;
  int size{0};
};

auto main() -> int {
  std::ifstream file("input/Day7.txt");
  assert(file);
  std::string line;
  vs lines;
  while (std::getline(file, line)) lines.push_back(line);

  std::vector<Directory> dir;
  std::vector<std::string> tmp_dir;
  std::set<std::string> dir_names;

  for (auto word : lines) {
    if (word.size() > 5) {
      if (word[2] == 'c' && word[5] != '.') {
        tmp_dir.push_back(std::move(word.substr(5)));
        dir_names.insert(tJoin(tmp_dir, '-'));
      } else if (word[5] == '.')
        tmp_dir.pop_back();
      else if (isdigit(word[0])) {
        auto p = tJoin(tmp_dir, '-');
        auto s = std::stoi(word.substr(0, word.find(' ')));
        dir.emplace_back(Directory{p, s});
      }
    }
  }

  std::vector<int> ttl;
  for (auto i : dir_names) {
    int sum{0};
    for (auto j : dir) {
      if (j.path.find(i) < j.path.size()) sum += j.size;
    }
    ttl.push_back(sum);
  }

  auto filter1 =
      ttl | std::ranges::views::filter([](auto x) { return x <= 100'000; });
  auto filter2 = ttl | std::ranges::views::filter(
                           [ttl](auto x) { return x >= ttl[0] - 40'000'000; });

  auto pt1 = std::accumulate(filter1.begin(), filter1.end(), 0);
  auto pt2 = *std::ranges::min_element(filter2);

  std::cout << "Part 1: " << pt1 << "\nPart 2: " << pt2 << std::endl;
}
