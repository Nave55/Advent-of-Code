#include "tools.h"
#include <iostream>
#include <fstream>
#include <unordered_map>
#include <algorithm>

struct ParseFile {std::unordered_map<int, vi> mp {}; vvi mat {};};
struct SortArr {vi vals; bool is_sorted;};
auto solution() -> void;

auto main() -> int {
    solution();
}

auto parseFile() -> ParseFile {
    std::ifstream file ("input/day5.txt");
    assert(file);
    std::string line;

    std::unordered_map<int, vi> mp {}; 
    vvi mat {};
    while (std::getline(file, line)) {
        if (line != "") {
            if (line.contains("|")) {
                auto a = tSplit<int>(line, '|');
                if (!mp.contains(a[0])) mp[a[0]] = {};
                mp[a[0]].emplace_back(a[1]);
            }
            if (line.contains(",")) {
                auto a = tSplit<int>(line);
                mat.emplace_back(a);
            }
        }
    }
    return {mp, mat};
}

auto sortArr(vi arr, const std::unordered_map<int, vi> &mp) -> SortArr {
    auto sorted =false;
    auto no_changes = true;

    while (!sorted) {
        sorted = true;
        for (auto i : arr) {
            if(mp.contains(i)) {
                for (auto k : mp.at(i)) {
                    auto i_pos = std::find(arr.begin(), arr.end(), i);
                    auto k_pos = std::find(arr.begin(), arr.end(), k);
                    if (k_pos != arr.end() && i_pos > k_pos) {
                        int i_ind = std::distance(arr.begin(), i_pos);
                        int k_ind = std::distance(arr.begin(), k_pos);
                        std::swap(arr[i_ind], arr[k_ind]);
                        sorted = false;
                        no_changes = false;
                    }
                }
            }
        }
    }

    return {arr, no_changes};
}

auto solution() -> void {
    auto [mp, mat] = parseFile();
    auto pt1 = 0, pt2 = 0;
        for (const auto &i : mat) {
            auto [vals, is_sorted] = sortArr(i, mp);
            auto n = (int) ((vals.size() - 1) / 2);
            if (is_sorted) pt1 += vals[n];
            else pt2 += vals[n];
        }
    printf("Part 1: %d\nPart 2: %d\n", pt1, pt2);
}
