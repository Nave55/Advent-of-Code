import StringTools.*;
import Std.*;
import Tools;

using hx.strings.Strings;
using Lambda;

class Day1 {
    static function main() {
        var lr = parse_file();
        var sol = solution(lr.left, lr.right);
        Sys.println('Part 1: ${sol.pt1}\nPart 2: ${sol.pt2}');
    }

    static function parse_file() {
        var con = [for (i in sys.io.File.getContent('input/Day1.txt').split("\r")) [for (j in i.split("   ")) parseInt(j) ?? 0]];
        var left = [for (i in con) i[0]];
        var right = [for (i in con) i[1]];

        left.sort((a, b) -> a - b);
        right.sort((a, b) -> a - b);

        return {left: left, right: right};
    }

    static function solution(left: ANI, right: ANI) {
        var l_map: MII = [for (i in left) i => 0];
        var ttl = 0, ttl2 = 0;

        for (i in 0...left.length) {
            ttl += Std.int(Math.abs(left[i] - right[i]));
             if (l_map.exists(right[i])) ttl2 += right[i];
        }

        return {pt1: ttl, pt2: ttl2};
    }
}
