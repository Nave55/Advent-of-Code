import Std.parseInt;
import StringTools.trim;

class Day1 {
    static function main() {
        var con = [for (i in sys.io.File.getContent('Advent Files_2021/Day1.txt').split('\n')) parseInt(trim(i))];
        var cnt = 0, cnt1 = 0, csum = 0, psum = 0;
        for (i in 1...con.length) {
            if (con[i] - con[i-1] > 0) cnt++;
        }
        for (i in 0...con.length - 2) {
            psum = csum;
            csum = con[i] + con[i+1] + con[i+2];
            if (psum != 0 && csum > psum) cnt1++; 
        }
        Sys.println('Part 1: $cnt\nPart 2: $cnt1');
    }
}