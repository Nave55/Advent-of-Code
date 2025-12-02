import StringTools.*;

class Day2_2022 {
    static function main() {
        var con = [for (i  in replace(sys.io.File.getContent('Advent Files_2022/Day2.txt'), " ", "").split("\n")) trim(i)];
        var sum = 0, sum1 = 0;
        var rps = ['AX' => 4, 'AY' => 8, 'AZ' => 3, 'BX' => 1, 'BY' => 5, 'BZ' => 9, 'CX' => 7, 'CY' => 2, 'CZ' => 6];
        var rps1 = ['AX' => 3, 'AY' => 4, 'AZ' => 8, 'BX' => 1, 'BY' => 5, 'BZ' => 9, 'CX' => 2, 'CY' => 6, 'CZ' => 7];
        for (i in con) {
            sum += rps[i];
            sum1 += rps1[i];
        }
        Sys.println('Part 1: $sum\nPart 2: $sum1');
    }
}
