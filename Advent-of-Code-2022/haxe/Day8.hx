import StringTools.*;
import Std.*;
import Tools;

using hx.strings.Strings;
using Lambda;

class Day8 {
    static function main() {
        var s: AS = [for (i in sys.io.File.getContent('Advent Files_2022/Day8.txt').split('\n')) trim(i)];
        var count:Float = (s.length * 4) - 4;
        var scores: AI = []; 

        for (rows in 1...s.length - 1) {
            for (cols in 1...s.length - 1) {
                var pos = parseInt(s[rows].charAt(cols));
                var left:   AI =   [for (i in 1...cols + 1)         parseInt(s[rows].charAt(cols - i))];
                var right:  AI =   [for (i in 1...s.length - cols)  parseInt(s[rows].charAt(cols + i))];
                var top:    AI =   [for (i in 1...rows + 1)         parseInt(s[rows - i].charAt(cols))];
                var bottom: AI =   [for (i in 1...s.length - rows)  parseInt(s[rows + i].charAt(cols))];

                if (maxVal(left) < pos || maxVal(right) < pos || maxVal(top) < pos || maxVal(bottom) < pos) count++;
                
                var score = 1;
                for (lst in [left, right, top, bottom]) {
                    var tracker = 0;
                    for (i in 0...lst.length) {
                        if (lst[i] < pos) tracker++;
                        else if (lst[i] == pos) {
                            tracker++;
                            break;
                        }
                        else break;
                    }

                    score *= tracker;
                    scores.push(score);
                }
            }
        }
        Sys.println('Part 1: ${count}\nPart 2: ${maxVal(scores)}');
    }
}
