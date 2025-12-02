#include "tl/getlines.hpp"
#include "tl/to.hpp"
#include "tools.h"
#include "iostream"
#include "fstream"
#include "vector"

int main() {
    std::ifstream file ("C:/Users/navez/Cpp_Projects/AoC/Advent_2022_Files/Day4.txt");
    auto lines = tl::views::getlines(file) | tl::to<std::vector>();
    for (size_t i {0}; i < lines.size(); i++) std::replace(lines[i].begin(), lines[i].end(), '-', ',');
    auto s = split(lines, ',');

   int sum {0}, sum2 {0};
   for (size_t i {0}; i < s.size() - 3; i += 4) {
        if ((s.at(i + 0) >= s.at(i + 2) && s.at(i + 1) <= s.at(i + 3)) || 
            (s.at(i + 2) >= s.at(i + 0) && s.at(i + 3) <= s.at(i + 1))) sum++;

        if ((s.at(i + 0) >= s.at(i + 2) && s.at(i + 0) <= s.at(i + 3)) || 
            (s.at(i + 1) >= s.at(i + 2) && s.at(i + 1) <= s.at(i + 3)) || 
            (s.at(i + 2) >= s.at(i + 0) && s.at(i + 2) <= s.at(i + 1)) || 
            (s.at(i + 3) >= s.at(i + 1) && s.at(i + 3) <= s.at(i + 0))) sum2++;       
   }

   printf("Part 1: %d\nPart 2: %d", sum, sum2);
}
