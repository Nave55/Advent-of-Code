import Std.*;
import Tools;

using hx.strings.Strings;
using Lambda;

class Day5 {
    static var mp:Map<Int, AI> = [];
    static var mat:AAI = [];
    static function main() {
        parse_file();
        var sol = solution();
        Sys.println('Part 1: ${sol.pt1}\nPart 2: ${sol.pt2}');
    }

    static function parse_file() {
        var con = [for (i in sys.io.File.getContent('input/Day5.txt').trim().split('\r\n')) if (i != "") i];
        for (i in con) {
            if (i.contains('|')) {
                var tmp: AI = i.split('|').map(item -> parseInt(item) ?? 0);
                if (mp.exists(tmp[0]) == false) mp[tmp[0]] = [];
                mp[tmp[0]].push(tmp[1]);
            }
            if (i.contains(',')) mat.push(i.split(',').map(item -> parseInt(item) ?? 0));
        }
    }

    static function sortArr(arr: AI) {
        var sorted = false;
        var no_changes = true;
        
        while (!sorted) {
            sorted = true;
            for (i in arr) {
                if (mp.exists(i)) {
                    for (k in mp[i]) {
                        var i_pos = arr.indexOf(i);
                        var k_pos = arr.indexOf(k);
                        if (k_pos != -1 && i_pos > k_pos) {
                            var tmp = arr[i_pos];
                            arr[i_pos] = arr[k_pos];
                            arr[k_pos] = tmp;
                            sorted = false;
                            no_changes = false;
                        }
                    }
                }
            }
        }
        return {arr: arr, sorted: no_changes};
    }

    static function solution() {
        var pt1 = 0, pt2 = 0;
        for (i in mat) {
            var info = sortArr(i);
            var n = Std.int((info.arr.length - 1) / 2);
            if (info.sorted) pt1 += info.arr[n];
            else pt2 += info.arr[n];
        }
        return {pt1: pt1, pt2: pt2};
    }
}