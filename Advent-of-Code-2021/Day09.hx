import Std.*;
import Tools;

using hx.strings.Strings;
using Lambda;

class Day9 {
    static function main() {
        var arr = parsefile();
        var s1 = solution1(arr);
        var s2 = solution2(arr, s1.lows);
        Sys.println('Part 1: ${s1.pt1}\nPart 2: ${s2}');
    }

    static inline function parsefile() {
        return [
            for (i in sys.io.File.getContent('input/day9.txt').split('\n')) 
            i
            .trim()
            .split('')
            .map(item -> parseInt(item) ?? 0)
        ]; 
    }

    static function solution1(arr: AAI) {
        var ttl = 0;
        var lows: AV2 = [];
        for (row => rval in arr) {
            for (col => cval in rval) {
                var tmp = nbrs(arr, {x: row, y: col}).vals;
                if (tmp.filter(item -> cast(item, Int) ?? 0 > cval).length == tmp.length) {
                    ttl += cval + 1;
                    lows.push({x: row, y: col});
                }
            }
        }
        
        return {lows: lows, pt1: ttl};
    }

    static function basinSize(arr: AAI, start: Vec2): Int {
        var seen: MSI = [];
        var stack: AV2 = [start];

        while (stack.length > 0) {
            var p = stack.pop();
            var key = vecToStr(p);

            if (seen.exists(key)) continue;
            var v = fetchVal(arr, p);
            if (v == 9) continue;

            seen[key] = v;
            for (n in nbrs(arr, p).indices) {
                var nv = fetchVal(arr, n);
                if (nv > v && nv != 9 && !seen.exists(vecToStr(n))) {
                    stack.push(n);
                }
            }
        }

        return seen.count();
    }

    static function solution2(arr: AAI, lows: AV2): Int {
        var sizes = [for (p in lows) basinSize(arr, p)];
        sizes.sort((a, b) -> b - a);
        return intProd(sizes.slice(0, 3));
    }
}import Std.*;
import Tools;

using hx.strings.Strings;
using Lambda;

class Day9 {
    static function main() {
        var arr = parsefile();
        var s1 = solution1(arr);
        // trace(s1.lows);
        var s2 = solution2(arr, s1.lows);
        Sys.println('Part 1: ${s1.pt1}\nPart 2: ${s2}');
    }

    static inline function parsefile() {
        return [
            for (i in sys.io.File.getContent('input/day9.txt').split('\n')) 
            i
            .trim()
            .split('')
            .map(item -> parseInt(item) ?? 0)
        ]; 
    }

    static function solution1(arr: AAI) {
        var ttl = 0;
        var lows: AV2 = [];
        for (row => rval in arr) {
            for (col => cval in rval) {
                var tmp = nbrs(arr, {x: row, y: col}).vals;
                if (tmp.filter(item -> cast(item, Int) ?? 0 > cval).length == tmp.length) {
                    ttl += cval + 1;
                    lows.push({x: row, y: col});
                }
            }
        }
        
        var m = [for (i in lows) [vecToStr(i) => fetchVal(arr, i)]];
        return {lows: lows, m: m, pt1: ttl};
    }

    static function basinSize(arr: AAI, start: Vec2): Int {
        var seen: MSI = [];
        var stack: AV2 = [start];

        while (stack.length > 0) {
            var p = stack.pop();
            var key = vecToStr(p);

            if (seen.exists(key)) continue;
            var v = fetchVal(arr, p);
            if (v == 9) continue;

            seen[key] = v;
            for (n in nbrs(arr, p).indices) {
                var nv = fetchVal(arr, n);
                if (nv > v && nv != 9 && !seen.exists(vecToStr(n))) {
                    stack.push(n);
                }
            }
        }

        return seen.count();
    }

    static function solution2(arr: AAI, lows: AV2): Int {
        var sizes = [for (p in lows) basinSize(arr, p)];
        sizes.sort((a, b) -> b - a);
        return intProd(sizes.slice(0, 3));
    }
}
