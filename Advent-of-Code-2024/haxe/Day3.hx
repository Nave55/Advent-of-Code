import Std.*;
import Tools;

using hx.strings.Strings;
using Lambda;

class Day3 {
    static function main() {
        solution(parse_file());
    }

    static function parse_file(): AAI {
        var con = sys.io.File.getContent('input/Day3.txt').trim();
        var re = ~/mul\(\d+,\d+\)|do(n't)?\(\)/i;
        var arr: AAI = [];
        while(re.match(con)) {
            var match = re.matched(0)
            .replaceAll("mul","")
            .replaceAll("don't()", "0")
            .replaceAll("do()", "1")
            .replaceAll("(", "")
            .replaceAll(")", "")
            .split(",")
            .map(item -> parseInt(item) ?? 0);
            
            arr.push(match);             
            con = re.matchedRight();
        }
        
        return arr;
    }

    static function solution(arr: AAI) {
        var pt1 = 0, pt2 = 0, mul = true;

        for (i in arr) {
            if (i.length == 1) mul = i[0] == 1 ? true : false;
            else {
                pt1 += i[0] * i[1];
                if (mul) pt2 += i[0] * i[1];
            }
        }   

        Sys.println('Part 1: ${pt1}\nPart 2: ${pt2}');
    }
}