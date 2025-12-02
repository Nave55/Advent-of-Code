#include "tools.h"
#include <tl/getlines.hpp>
#include <tl/to.hpp>
#include <print>
#include <iostream>
#include <fstream>

int main() {
    std::ifstream file ("C:/Users/navez/Cpp_Projects/AoC/Advent_2022_Files/Day8.txt");
    auto s = tl::views::getlines(file) | tl::to<std::vector<std::string>>();

    int count = (s.size() * 4) - 4;
    std::vector<int> scores;

    for (size_t rows {1}; rows < s.size() - 1; rows++) {
        for (size_t cols {1}; cols < s[cols].size() - 1; cols++) {
            int pos = (int) s[rows][cols];
            std::vector<int> left, right, top, bottom;

            for (size_t i {1}; i < cols + 1; i++) left.emplace_back((int) s[rows][cols - i]);
            for (size_t i {1}; i < s.size() - cols; i++) right.emplace_back((int) s[rows][cols + i]);
            for (size_t i {1}; i < rows + 1; i++) top.emplace_back((int) s[rows - i][cols]);
            for (size_t i {1}; i < s.size() - rows; i++) bottom.emplace_back((int) s[rows + i][cols]);

            if (maxVal(left) < pos || maxVal(right) < pos || maxVal(top) < pos || maxVal(bottom) < pos) count++;

            int score {1};
            for (const auto &lst: {left, right, top, bottom}) {
                int tracker {0};
                for (size_t i {0}; i < lst.size(); i++) {
                    if (lst[i] < pos) tracker++;
                    else if (lst[i] == pos) {
                        tracker++;
                        break;
                    }
                    else break;
                }
                score *= tracker;
                scores.emplace_back(score);
            }
        }
    }
    
    std::print("Part 1: {}\nPart 2: {}\n", count, maxVal(scores));
}
