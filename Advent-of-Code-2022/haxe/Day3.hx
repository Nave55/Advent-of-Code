import hx.strings.Char;
import StringTools.*;
import Std.*;
import Tools;

using hx.strings.Strings;
using Lambda;

class Day3 {
    static var alph = new Map<Char, Int>();
    static function main() {
        for (i in 1...27) {
             alph[(i + 96).toChar()] = i;
             alph[(i + 64).toChar()] = i + 26;
        }
        var data = [for (i in sys.io.File.getContent('Advent Files_2022/Day3.txt').split('\n')) trim(i)];
        var pt1 = solution1(data), pt2 = solution2(data);
        Sys.println('Solution 1: $pt1\nSolution 2: $pt2');
    }

    static function solution1(arr: AS) {
        var sum = 0;
        for (i in arr) {
            var n = int(i.length / 2);
            var a = new Set<String>(i.substring(0, n).split(''));
            var b = i.substring(n).split('');
            sum += alph[(a & b)[0]];
        }
        return sum;
    }

    static function solution2(arr: AS) {
        var sum = 0;
        for (i in 0...Std.int(arr.length / 3)) {
            var a = new Set<String>(arr[i * 3].split(''));
            var b = new Set<String>(arr[i * 3 + 1].split(''));
            var c = arr[i * 3 + 2].split('');
            sum += alph[(a & (b & c))[0]];

        }
        return sum;
    }
}
