import Tools;
import Std.*;
import haxe.Int64;

using hx.strings.Strings;
using Lambda;

typedef FileInfo = {val: Int, pos: Int, size: Int};
typedef AFI = Array<FileInfo>;

class Day9 {
    static function main() {
        var con = parse_file();
        var pt1 = solution(con.arr);
        var pt2 = solutionTwo(con.filled, con.empty);
        Sys.println('Part 1: ${pt1}\nPart 2: ${pt2}');
    }

    static function parse_file() {
        var arr: AI = [], filled: AFI = [], empty: AFI = [];

        var f_val = 0, idx = 0;
        for (ind => i in sys.io.File.getContent('input/Day9.txt').toChars()) {
            var times = parseInt(i) ?? 0;
            if (ind % 2 == 0) {
                for (_ in 0 ... times) arr.push(f_val);
                if (times > 0) {
                    filled.push({val: f_val, pos: idx, size: times});
                    f_val++;
                }
            } else {
                for (_ in 0 ... times) arr.push(-1);
                if (times > 0) empty.push({val: -1, pos: idx, size: times});
            }
            idx += times;
        }

        return {arr: arr, filled: filled, empty: empty};
    }

    static function solution(arr: AI) {
        var j = arr.length - 1;
        var ttl: Int64 = 0;
        for (i in 0 ... arr.length) {
            if (arr[i] == -1) {
                while (j > i && arr[j] < 0) j--;
                if (j <= i) break;
                arr[i] = arr[j];                
                arr[j] = -1;
            }
            if (arr[i] >= 0) ttl += i * arr[i];
        }

        return ttl;
    }

    static function solutionTwo(filled: AFI, empty: AFI): Int64 {
        var ttl: Int64 = 0;

        for (i in new ReverseIterator(filled.length - 1, 0)) {
            for (j in 0 ... empty.length) {
                if (filled[i].pos <= empty[j].pos) break;
                if (filled[i].size <= empty[j].size) {
                    filled[i].pos = empty[j].pos;
                    empty[j].size -= filled[i].size;
                    empty[j].pos += filled[i].size;
                    break;
                }
            }
        }

        for (i in filled) {
            for (ind in i.pos ... (i.pos + i.size)) ttl += i.val * ind;
        }

        return ttl;
    }
}
