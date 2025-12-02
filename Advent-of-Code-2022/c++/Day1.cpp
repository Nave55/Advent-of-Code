#include "tools.h"
#include <tl/getlines.hpp>
#include <tl/to.hpp>
#include <fstream>

int main() {
    std::ifstream file ("C:/Users/navez/Cpp_Projects/AoC/Advent_2022_Files/Day1.txt");
    auto lines = tl::views::getlines(file) | tl::to<std::vector<std::string>>();

    std::vector<int> vec;
    int ttl {0};
    for (const auto &i : lines) {
        if (i != "") ttl += std::stoi(i);
        else {
            vec.emplace_back(ttl);
            ttl = 0;
        }
    }
    std::partial_sort(vec.begin(), vec.begin() + 3, vec.end(), std::greater<int> {});
    auto part1 = vec.at(0);
    auto part2 = std::accumulate(vec.begin(), vec.begin() + 3, 0);
    printf("Part 1: %d\nPart 2: %d", part1, part2);
}
