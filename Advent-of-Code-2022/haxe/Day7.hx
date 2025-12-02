import StringTools.*;
import Std.*;
import Tools;

using hx.strings.Strings;

typedef Directory = {path: String, size: Int}

class Day7 {
    static function main() {
        var arr: AS = [for (i in sys.io.File.getContent('Advent Files_2022/Day7.txt').split('\n')) trim(i)];
        var uniq_names: AS = [], tmp: AS = [], dir: Array<Directory> = [];
        for (i in arr) {
            if (i.charAt(2) == 'c' && i.charAt(5) != '.') {
                tmp.push(i.substr(5, i.length));
                uniq_names.push(tmp.join('-'));
            }
            else if (i.charAt(2) == 'c' && i.charAt(5) == '.') tmp.pop();
            else if (i.charAt(0).isDigits()) {
                var p = tmp.join('-');
                var s = parseInt(i.substr(0, i.indexOf(' ')));
                dir.push({path: p, size: s});
            }
        }

        var arr_sum:AI = [];
        for (i in uniq_names) {
            var sum = 0;
            for (j in dir) {
                if (j.path.contains(i)) sum += j.size;
            }
            arr_sum.push(sum);
        }
        
        var pt1 = intSum(arr_sum.filter(item -> item <= 100_000)); 
        var pt2 = minVal(arr_sum.filter(item -> item >= arr_sum[0] - 40_000_000));
        Sys.println('Part 1: $pt1\nPart 2: $pt2');
    }
}
