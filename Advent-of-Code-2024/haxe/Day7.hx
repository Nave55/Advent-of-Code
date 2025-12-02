import haxe.Int64;
import Tools;

using hx.strings.Strings;
using Lambda;

class Day7 {
    static var target: AI64 = [];
    static var seq: Array<AI64> = [];
    static function main() {
        parse_file();
        var sol = solution();
        Sys.println('Part 1: ${sol.pt1}\nPart 2: ${sol.pt2}');
    }

    static function parse_file() {
        var con = [for (i in sys.io.File.getContent('input/Day7.txt').trim().split('\r\n')) i];
        for (i in con) {
            var tmp = i.split(": ").join(" ").split(" ").map(item -> Int64.parseString(item));
            target.push(tmp[0]);
            seq.push(tmp.slice(1));
        }
    }

    static inline function concat(a: Int64, b: Int64): Int64 {
        return Int64.parseString('${a}${b}');
    }

    static function solver(nums: AI64, target: Int64, index, cur_value: Int64, pt1: Bool): Bool {
        if (index == 0) return solver(nums, target, index + 1, nums[0], pt1);
        if (index == nums.length) return cur_value == target;

        var num = nums[index];
        if (solver(nums, target, index + 1, cur_value + num, pt1)) return true;
        if (solver(nums, target, index + 1, cur_value * num, pt1)) return true;
        if (!pt1 && solver(nums, target, index + 1, concat(cur_value, num), pt1)) return true;
        return false;
    }

    static function solution() {
        var pt1: Int64 = 0;
        var pt2: Int64 = 0;
        for (ind => val in seq) {
            if (solver(val, target[ind], 0, 0, true)) pt1 += target[ind];
            if (solver(val, target[ind], 0, 0, false)) pt2 += target[ind];
        }
        return {pt1: pt1, pt2: pt2};
    }
}
