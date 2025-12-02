#include "tools.h"
#include <iostream>
#include <fstream>
#include <cassert>

typedef std::array<long long, 850> all;
typedef std::array<std::vector<int>, 850> avi;

struct ParseFile {all targets; avi nums;};

auto parseFile() -> ParseFile;
auto solution(const all &a, const avi &b) -> void;

auto main() -> int {
    auto [targets, nums] = parseFile();
    solution(targets, nums);
}

auto parseFile() -> ParseFile {
    std::array<long long, 850> targets {};
    std::array<std::vector<int>, 850> nums {{}};
    
    std::ifstream file ("input/day7.txt");
    assert(file);
    std::string line;

    size_t ind {0};
    while (std::getline(file, line)) {
        auto t = tSplit<std::string>(line, ':');

        targets[ind] = std::stoll(t[0]);

        t[1].erase(t[1].begin());
        nums[ind] = tSplit<int>(t[1], ' ');

        ind++;
   }
   
   return {targets, nums};
}

auto concat(long long a, long long b) -> long long {
    return  std::stoll(std::to_string(a) + std::to_string(b));
}

auto evaluate(const vi &nums, long long target, size_t index, long long curr_val, bool pt1) -> bool {
	if (index == 0) {
		return evaluate(nums, target, index + 1, nums[0], pt1);
	}

	if (index == nums.size()) {
		return curr_val == target;
	}

	auto num = (long long) nums[index];

	if (evaluate(nums, target, index + 1, curr_val + num, pt1)) {
		return true;
	}
	if (evaluate(nums, target, index + 1, curr_val * num, pt1)) {
		return true;
	}
	if (!pt1 && evaluate(nums, target, index + 1, concat(curr_val, num), pt1)) {
		return true;
	}

	return false;
}

auto solution(const all &a, const avi &b) -> void {
    long long ttl1 = 0;
    long long ttl2 = 0;

    size_t ind {0};
    for (const auto &vals : b) {
        if (evaluate(vals, a[ind], 0, 0, true)) {
            ttl1 += a[ind];
        }

        if (evaluate(vals, a[ind], 0, 0, false)) {
            ttl2 += a[ind];
        }

        ++ind;
    }
     
    std::cout << "Part 1: " << ttl1 << "\nPart 2: " << ttl2 << "\n"; 
}
