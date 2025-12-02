import StringTools.*;
import Std.*;
import Math.*;
import haxe.macro.*;
import haxe.ds.*;
import Tools;

using hx.strings.Strings;
using Lambda;

class Day7 {
    static function main() {
        var arr = parsefile();
        solution1(arr);
    }

    static inline function parsefile() {
        return [for (i in sys.io.File.getContent('Advent Files_2021/Day7.txt').split(',')) parseInt(i)];
    }

    static function solution1(arr: AI) {
        arr.sort((a,b) -> a - b);
        var mid = arr[int(arr.length / 2)];
        var part1 = floatSum([for (i in arr) abs(i - mid)]);
        
        var mean = floor(intSum(arr) / arr.length);
        var calc = (x:Float) -> (x * (x + 1) / 2);
        var part2 = floatSum([for (x in arr) calc(abs(x - mean))]);
        Sys.println('Part 1: $part1\nPart 2: $part2');
    }
}