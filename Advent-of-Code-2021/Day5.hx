import StringTools.*;
import Std.*;
import Math.*;
import haxe.macro.*;
import haxe.ds.*;
import Tools;

using hx.strings.Strings;

class Day5 {
    static function main() {
        var con = parsefile();
        Sys.println('Part 1: ${solution(con,false)}\nPart 2: ${solution(con,true)}');
    }

    static inline function parsefile() {
        var arr:AAF = [];
        var tmp:AF = [];
        var cnt = 0;
        for (i in replace(replace(replace(sys.io.File.getContent(
            'Advent Files_2021/Day5.txt'), ' ', ''), '->',','),'\r',',').split(',')) {
            tmp.push(parseFloat(i));
            if (cnt == 3) {
                cnt = -1;
                arr.push(tmp);
                tmp = [];
            }
            ++cnt;
        }
        return arr;
    }
           
    static inline function solution(con:AAF, part2:Bool): Int {
        var matrix:AAI = [for (i in 0...1000) [for (j in 0...1000) 0]];

        for (i in 0...con.length) {
            var x0 = int(min(con[i][0], con[i][2])), y0 = int(min(con[i][1], con[i][3]));
            var x1 = int(max(con[i][0], con[i][2])), y1 = int(max(con[i][1], con[i][3]));

            if (con[i][0] == con[i][2] || con[i][1] == con[i][3]) {
                if (y0 != y1) {
                    for (y in y0...y1+1) matrix[y][x0] += 1;
                }
                else for (y in x0...x1+1) matrix[y0][y] += 1;
            }
            if ((abs(con[i][0] - con[i][2]) == abs(con[i][1] - con[i][3])) && part2 == true) {
                var arr = [], arr2 = [];
                var ax = int(con[i][0]), ay = int(con[i][1]);
                var bx = int(con[i][2]), by = int(con[i][3]);

                if (ax < bx) {
                    arr = [for (i in ax...bx+1) i];
                }
                if (ax >= bx) {
                    arr = [for (i in bx...ax + 1) i];
                    arr.sort((a,b) -> b - a);
                }
                if (ay < by) {
                    arr2 = [for (i in ay...by + 1) i];
                }
                if (ay >= by) {
                    arr2 = [for (i in by...ay + 1) i];
                    arr2.sort((a,b) -> b - a);
                }
                for (i in 0...arr.length) {
                    matrix[arr2[i]][arr[i]] += 1;
                }
            }
        }
        
        var sum = 0;
        for (i in matrix) {
            for (j in i) {
                if (j > 1) ++sum;
            }
        }
        return sum;
    }
}