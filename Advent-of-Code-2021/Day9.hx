import StringTools.*;
import Std.*;
import Tools;

using hx.strings.Strings;
using Lambda;

class Day9 {
    static function main() {
        var arr = parsefile();
        var s1 = solution1(arr);
        var s2 = solution2(arr, [for (i in s1.lows) [i]], s1.m);
        Sys.println('Part 1: ${s1.pt1}\nPart 2: ${s2}');
    }

    static inline function parsefile() {
        return [for (i in sys.io.File.getContent('Advent Files_2021/Day9.txt').split('\n')) trim(i).split('').map(item -> parseInt(item))]; 
    }

    static function solution1(arr: AANI) {
        var ttl = 0;
        var lows: AAI = [];
        for (row => rval in arr) {
            for (col => cval in rval) {
                var tmp = nbrs(arr, [row, col]).vals;
                if (tmp.filter(item -> cast(item, Int) > cval).length == tmp.length) {
                    ttl += cval + 1;
                    lows.push([row, col]);
                }
            }
        }
        
        var m = [for (i in lows) [i.join("") => cast(arrValue(arr, i), Int)]];
        return {lows: lows, m: m, pt1: ttl};
    }

    static function solution2(arr: AANI, lows: AAAI, m: Array<MSI>) {
        if (lows.count(item -> item.empty()) == lows.length) {
            var sol = [for (i in m) i.count()];
            sol.sort((a, b) -> b - a);
            return intProd(sol.slice(0, 3));
        } 

        for (ind => i in lows) {
            var tmp: AAI = [];
            for (j in i) {
                var lowest: Int = arrValue(arr, j);
                var n4 = nbrs(arr, j).indices.filter(item -> arrValue(arr, item) != 9 && 
                                                     cast(arrValue(arr, item), Int) > lowest && 
                                                     !m[ind].exists(item.join("")));
                tmp = tmp.concat(n4);
                for (vals in n4) m[ind][vals.join("")] = arrValue(arr, vals);
            }
            lows[ind] = tmp;
        }

        return solution2(arr, lows, m);
    }   
}
