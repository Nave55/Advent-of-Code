#include "tools.h"
#include <iostream>
#include <fstream>
#include <unordered_map>
#include <unordered_set>
#include <cassert>

constexpr int ROWS = 50;
constexpr int COLS = 50;

typedef std::pair<int, int> pi; 
typedef std::array<std::array<char, COLS>, ROWS> aac; 
typedef std::unordered_map<char, std::vector<pi>> mcvpi;
typedef std::unordered_map<pi, std::vector<pi>, pair_hash> mpivpi;
typedef std::unordered_set<pi, pair_hash> spi;

struct ParseFile {aac arr; mcvpi mp;};

auto parseFile() -> ParseFile;
auto antSlopes(const mcvpi &ants) -> mpivpi;
auto solution(const aac &arr, const mpivpi &slopes) -> size_t;
auto solution2(const mpivpi &slopes) -> size_t;

auto main() -> int {
    auto [arr, ants] = parseFile();
    auto slopes = antSlopes(ants);
    auto sol1 = solution(arr, slopes);
    auto sol2 = solution2(slopes);

    std::printf("Part 1: %zu\nPart 2: %zu", sol1, sol2);
}

auto parseFile() -> ParseFile {
    aac arr {{'.'}}; 
    mcvpi mp {{}};

    std::ifstream file ("input/day8.txt");
    assert(file);
    std::string line;

    size_t r_ind {0};
    while (std::getline(file, line)) {
        for (size_t c_ind {0}; c_ind < line.size(); ++c_ind) { 
            arr[r_ind][c_ind] = line[c_ind];
            if (mp.count(line[c_ind]) == 0) mp[line[c_ind]] = {};
            if (line[c_ind] != '.') mp[(char) line[c_ind]].emplace_back((int) r_ind, (int) c_ind);
        }
        ++r_ind;   
    }

    return {arr, mp};
}

auto antSlopes(const mcvpi &ants) -> mpivpi {
    mpivpi slopes {};

    for (const auto &vals : ants) {
        if (vals.second.size() < 2) continue;  
    
        for (size_t i {0}; i < vals.second.size() - 1; ++i) {
            for (size_t j {i + 1}; j < vals.second.size(); ++j) {
                slopes[vals.second[i]].emplace_back(vals.second[i] - vals.second[j]);
            }
        }
    }

    return slopes;
}

auto solution(const aac &arr, const mpivpi &slopes) -> size_t {
    spi sol1 {};

    for (const auto &vals : slopes) {
        for (const auto &i : vals.second) {
            auto vec = vals.first;
            char symb = inBounds(i, ROWS, COLS) ? arr[i.first][i.second] : '*';
            auto pos = i + vals.first;
            auto neg = vec - (i * 2);

            if (inBounds(pos, ROWS, COLS) && arrValue(arr, pos) != symb) {
                sol1.emplace(pos);
            }

            if (inBounds(neg, ROWS, COLS) && arrValue(arr, neg) != symb) {
                sol1.emplace(neg);
            }
        }
    }

    return sol1.size();
}

auto solution2(const mpivpi &slopes) -> size_t {
    spi sol2 {};

    for (const auto &vals : slopes) {
        auto key = vals.first;
        auto value = vals.second;
        sol2.emplace(key);

        for (const auto &i : value) {
            auto val = key;
            while (true) {
                val = val + i;
                if (inBounds(val, ROWS, COLS)) {
                    sol2.emplace(val);
                } else {
                    val = key;
                    break;
                }
            }
            while (true) {
                val = val - i;
                if (inBounds(val, ROWS, COLS)) {
                    sol2.emplace(val);
                } else {
                    break;
                }   
            }
        }
    }
    
    return sol2.size();
}
