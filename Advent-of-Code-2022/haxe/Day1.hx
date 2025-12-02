import Std.*;
import Tools;

using hx.strings.Strings;
using Lambda;

class Day1_2022 {
    static function main() {
        var con = [for (i in sys.io.File.getContent(
            'Advent Files_2022/Day1.txt').replaceAll('\r','').split('\n')) i.isDigits() ? parseInt(i) : 0];
        var arr: AI = [];
        con.fold((num, ttl) -> {(num != 0) ? return ttl += num : arr.push(ttl); ttl=0;}, 0);
        arr.sort((a, b) -> b - a);
        Sys.println('Part 1: ${arr[0]}\nPart 2: ${intSum(arr.slice(0,3))}');
    }
}
