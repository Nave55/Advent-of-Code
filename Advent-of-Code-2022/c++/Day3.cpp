#include "tl/getlines.hpp"
#include "tl/to.hpp"
#include "tools.h"
#include "iostream"
#include "fstream"
#include "algorithm"
#include "ranges"
#include "vector"
#include "string"
#include "unordered_map"

auto solution1(const std::vector<std::string> &s, const std::unordered_map<char, int> &mp) -> int;
auto solution2(const std::vector<std::string> &s, const std::unordered_map<char, int> &mp) -> int;

int main() {
    std::unordered_map<char, int> mp;
    for (size_t i {0}; i < 26; i++) {
        char letter = 97 + i;
        char letter_u = 65 + i;
        mp.insert(std::pair<char,int>(letter,i+1));
        mp.insert(std::pair<char,int>(letter_u,i+27));
    }

    std::ifstream file ("C:/Users/navez/Cpp_Projects/AoC/Advent_2022_Files/Day3.txt");
    auto lines = tl::views::getlines(file) | tl::to<std::vector>();

    std::printf("Part 1: %d\nPart 2: %d\n", solution1(lines, mp), solution2(lines, mp));
}

auto solution1(const std::vector<std::string> &s, const std::unordered_map<char, int> &mp) -> int {
    int ttl {0};
    for (auto i: s) {
        std::string inter {""};
        auto str1 = i.substr(0, i.size() / 2);
        auto str2 = i.substr(i.size() / 2);
        std::sort(str1.begin(), str1.end());
        std::sort(str2.begin(), str2.end());
        std::set_intersection(str1.begin(), str1.end(), str2.begin(), str2.end(), std::back_inserter(inter));
        ttl += mp.at(inter.at(0));
    }
    return ttl;
}

auto solution2(const std::vector<std::string> &s, const std::unordered_map<char, int> &mp) -> int {
    int ttl {0};
    for (size_t i {0}; i < s.size() - 2; i += 3) {
        std::string inter, inter2;
        auto str1 = s.at(i), str2 = s.at(i + 1), str3 = s.at(i + 2);
        std::sort(str1.begin(), str1.end());
        std::sort(str2.begin(), str2.end());
        std::sort(str3.begin(), str3.end());
        std::set_intersection(str1.begin(), str1.end(), str2.begin(), str2.end(), std::back_inserter(inter));
        std::set_intersection(inter.begin(), inter.end(), str3.begin(), str3.end(), std::back_inserter(inter2));
        ttl += mp.at(inter2.at(0));
    }
    return ttl;
}
