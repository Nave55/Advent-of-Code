import Std.*;
import Tools;

class Day2 {
    static function main() {
        var sol = solution();
        Sys.println('Part 1: ${sol.pt1}\nPart 2: ${sol.pt2}');
    }

    static function checkSafety(arr: AI): Bool {
        var n = arr.length - 1;
        if (n < 0) return true;
        
        var dec = 0, inc = 0;
        for (i in 0 ... arr.length - 1) {
            var val = arr[i] - arr[i + 1];
            if (val >= 1 && val <= 3) dec++;
            if (val <= -1 && val >= -3) inc++;
        }

        return dec == n || inc == n;
    }

    static function checkSafetyTwo(arr: AI): Bool {
        if (checkSafety(arr)) return true;

        for (i in 0 ... arr.length) {
            var tmp = arr.slice(0, i).concat(arr.slice(i + 1));
            if (checkSafety(tmp)) return true;
        }

        return false;
    }

    static function solution() {
        var con = [for (i in sys.io.File.getContent('input/Day2.txt').split("\r")) [for (j in i.split(" ")) parseInt(j) ?? 0]];
        var ttl = 0, ttl2 = 0;

        for (i in con) {
            if (checkSafety(i)) ttl++;
            if (checkSafetyTwo(i)) ttl2++;
        }

        return {pt1: ttl, pt2: ttl2};
    }
}
