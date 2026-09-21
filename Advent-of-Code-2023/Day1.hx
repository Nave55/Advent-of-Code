import StringTools.*;
import Std.*;
import Tools;

using hx.strings.Strings;

class Day1 {
    static function main() {
        var con = parsefile();
        var one = solution1(con);
        var two = solution2(con);
        Sys.println('Part 1: $one\nPart 2: $two');
    }

    static function parsefile() {
        return [for (i in sys.io.File.getContent('input/day1.txt').split('\n')) trim(i)];
    }

    static function solution1(con: AS): Int {
        var ttl = 0;
        for (i in con) {
            var tmp: AS = [];
            for (j in 0...i.length) {
                if (i.charAt(j).isDigits()) tmp.push(i.charAt(j));
            }
            ttl += parseInt(tmp[0] + tmp[tmp.length - 1]);
        }
        return ttl;
    }

    static function solution2(con: AS): Int {
        final names = [
            'one'   => 'one1one',
            'two'   => 'two2two',
            'three' => 'three3three',
            'four'  => 'four4four',
            'five'  => 'five5five',
            'six'   => 'six6six',
            'seven' => 'seven7seven',
            'eight' => 'eight8eight',
            'nine'  => 'nine9nine',
        ];

        final con2 = [
            for (i in con) {
                for (key => val in names) i = i.replaceAll(key, val);
                i;
            }
        ];

        return solution1(con2);
    }
}
