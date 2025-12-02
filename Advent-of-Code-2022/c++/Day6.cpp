#include <iostream>
#include <string>
#include <unordered_set>
#include <fstream>
#include <ranges>

auto solution(const std::string &con, size_t window) -> int;

int main() {
    std::ifstream file ("C:/Users/navez/Cpp_Projects/AoC/Advent_2022_Files/Day6.txt");
    std::string line;
    file >> line;
    std::printf("Part 1: %d\nPart 2: %d\n", solution(line, 4), solution(line, 14));
}

auto solution(const std::string &line, size_t window) -> int {
    auto a = line | std::views::slide(window);
    for (size_t i {0}; i < a.size(); i++) { 
        std::unordered_set<int> tmp(a[i].begin(), a[i].end());
        if (tmp.size() == window) return i + window;
    }
    return 0;   
}
