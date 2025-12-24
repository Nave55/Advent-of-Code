import StringTools.*;
import Std.*;
import Tools;

using hx.strings.Strings;

class Day1_2023 {
    static function main() {
        var con = parsefile();
        var one = solution1(con);
        var two = solution2(con);
        trace('\nPart 1: $one\nPart 2: $two');
    }

    static inline function parsefile() {
        var con:AS = [for (i in sys.io.File.getContent('Advent Files_2023/Day1.txt').split('\n')) trim(i)];
        return con;
    }

    static function solution1(con: AS): Int {
        var ttl = 0;
        for (i in con) {
            var tmp:AS = [];
            for (j in 0...i.length) {
                if (i.charAt(j).isDigits()) tmp.push(i.charAt(j));
            }
            ttl += parseInt(tmp[0] + tmp[tmp.length - 1]);
        }
        return ttl;
    }

    static function solution2(con: AS): Int {
        var names = ['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'];
        var ttl = 0;
        for (i in con) {
            var mp:MIS = new Map(); 
            var arr:AI = [];
            for (j in 0...i.length) {
                if (i.charAt(j).isDigits() == true) mp[j] = i.charAt(j);
            }
            for (ind => val in names) {
                mp[i.indexOf(val)] = string(ind+1);
                mp[i.lastIndexOf(val)] = string(ind+1); 
            }
            for (i in mp.keys()) if (i >= 0) arr.push(i);
            arr.sort((a,b) -> a-b);
            ttl += parseInt(mp[arr[0]] + mp[arr[arr.length - 1]]);
        }
        return ttl;
    }
}
