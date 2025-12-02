import Tools;
import StringTools.*;
using hx.strings.Strings;

class Day6 {
    static function main() {
        var data = [for (i in sys.io.File.getContent('Advent Files_2022/Day6.txt').split('\n')) trim(i)][0].split('');
        var pt1 = solution(data);
        var pt2 = solution(data, 14);
        Sys.println('Solution 1: $pt1\nSolution 2: $pt2');
    }

    static function solution(arr: AS, window = 4) {
        for (i in 0...arr.length - window + 1) {
            var a = new Set<String>(arr.slice(i, i + window));
            if (a++.length == window) return i + window;
        }
        return -1;
    }
}
