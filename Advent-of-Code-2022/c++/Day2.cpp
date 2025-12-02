#include "tl/getlines.hpp"
#include "tl/to.hpp"
#include <string>
#include <fstream>
#include <vector>
#include <map>
#include <unordered_map>
#include <ranges>
#include <iostream>

int main() {
    std::unordered_map<std::string, int> mp;
    std::unordered_map<std::string, std::string> mp2;

    mp["A X"] = 4; mp["A Y"] = 8; mp["A Z"] = 3;
    mp["B X"] = 1; mp["B Y"] = 5; mp["B Z"] = 9;
    mp["C X"] = 7; mp["C Y"] = 2; mp["C Z"] = 6;

    mp2["A X"] = "A Z"; mp2["A Y"] = "A X"; mp2["A Z"] = "A Y";
    mp2["B X"] = "B X"; mp2["B Y"] = "B Y"; mp2["B Z"] = "B Z";
    mp2["C X"] = "C Y"; mp2["C Y"] = "C Z"; mp2["C Z"] = "C X";

    int ttl1 {0}, ttl2 {0};
    std::ifstream file("C:/Users/navez/Cpp_Projects/AoC/Advent_2022_Files/Day2.txt");
    auto lines = tl::views::getlines(file) | tl::to<std::vector>();
    
    for (auto i : lines) {
        ttl1 += mp[i];
        ttl2 += mp[mp2[i]];
    }

    printf("Part 1: %d\nPart 2: %d\n", ttl1, ttl2);
}
