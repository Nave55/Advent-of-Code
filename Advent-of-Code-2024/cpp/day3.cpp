#include "tools.h"
#include <fstream>
#include <ranges>
#include <regex>

struct Pt1Pt2 {int pt1 {0}; int pt2 {0};};
auto solution() -> Pt1Pt2;

auto main() -> int {
    auto [sum1, sum2] = solution();
    printf("Part 1: %d\nPart 2: %d", sum1, sum2);
}

auto solution() -> Pt1Pt2 {
    std::ifstream file ("input/day3.txt");
    std::stringstream buffer; 
    buffer << file.rdbuf();
    auto lines = buffer.str();

    std::regex re(R"(mul\((\d+),(\d+)\)|do\(\)|don't\(\))");    
    auto words_begin = std::sregex_iterator(lines.begin(), lines.end(), re);
    auto words_end = std::sregex_iterator();

    int sum1 {0}, sum2 {0}, mul {true};
    for (std::regex_iterator i = words_begin; i != words_end; ++i) {
        std::smatch match = *i;
        if (match[0].str().substr(0, 4) == "mul(") {
            auto x = stoi(match[1].str());
            auto y = stoi(match[2].str());
            if (mul) sum2 += x * y;
            sum1 += x * y;
        }
        else {
            if (match[0].str() == "don't()") mul = false;
            else mul = true;
        }
    }

    return {sum1, sum2};
}
