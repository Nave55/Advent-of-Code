#include "tools.h"
#include <tl/getlines.hpp>
#include <tl/to.hpp>
#include <boost/algorithm/string.hpp>
#include <print>
#include <iostream>
#include <fstream>

auto solution1(const vvi &instructions, vvc crates) -> std::string;
auto solution2(const vvi &instructions, vvc crates) -> std::string;
void parsefile(vvc &crates, vvi &instructions);

int main() {
    vvi instructions;
    vvc crates {{}, {}, {}, {}, {}, {}, {}, {}, {}};  
    parsefile(crates, instructions);
    std::print("Part 1: {}\nPart 2: {}\n", solution1(instructions, crates), solution2(instructions, crates));
}

void parsefile(vvc &crates, vvi &instructions) {
    std::ifstream file ("C:/Users/navez/Cpp_Projects/AoC/Advent_2022_Files/Day5.txt");
    auto lines = tl::views::getlines(file) | tl::to<std::vector<std::string>>();

    for (size_t i {0}; i < lines.size(); ++i) {
        if (i < 8) {
            boost::replace_all(lines[i], "[", "");
            boost::replace_all(lines[i], "]", "");
            boost::replace_all(lines[i], "    ", "0");
            boost::replace_all(lines[i], " ", "");
            for (size_t j {0}; j < lines[i].size(); ++j) {
                if (lines[i][j] != '0') crates[j].insert(crates.at(j).begin(), lines[i][j]);
            }
        }
        if (i > 9) {
            boost::replace_all(lines[i], "move ", "");
            boost::replace_all(lines[i], " from ", ",");
            boost::replace_all(lines[i], " to ", ",");
            instructions.emplace_back(split(lines[i], ','));
        }
    }
}

auto solution1(const vvi &instructions, vvc crates) -> std::string {
    for (const auto &i : instructions) {
        for (int j {0}; j < i.at(0); j++) { 
            crates.at(i[2] - 1).emplace_back(crates.at(i[1] - 1).back());
            crates.at(i[1] - 1).pop_back();
        }
    }
    std::string result;
    for (const auto &i : crates) result += (i.back());
    
    return result;
}

auto solution2(const vvi &instructions, vvc crates) -> std::string {
    for (const auto &i : instructions) {
        vc tmp {}; 
        for (int j {0}; j < i[0]; j++) {
            tmp.emplace_back(crates[i[1] - 1].back());
            crates[i[1] - 1].pop_back();
        }
        std::reverse(tmp.begin(), tmp.end());
        crates[i[2] - 1].insert(crates[i[2] - 1].end(), tmp.begin(), tmp.end());
    }
    std::string result;
    for (const auto &i : crates) result += i.back();
    return result;
}
