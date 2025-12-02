import Std.*;
import Tools;

using hx.strings.Strings;

class Day5 {
    static function main() {
        var data = parsefile();
        var pt1 = solution1(data.crates, data.instr);
        var data = parsefile();
        var pt2 = solution2(data.crates, data.instr);
        Sys.println('Solution 1: $pt1\nSolution 2: $pt2');
    }

    static function parsefile() {
        var con: AS = [for (i in sys.io.File.getContent('Advent Files_2022/Day5.txt').split('\n')) i.replaceAll(
            "[", "").replaceAll("]", "").replaceAll("    ", "0").replaceAll(" ", "").trim()];
        var crates: AAS = [for (i in 0...9) []];
        var instructions: AAI = [];
        for (i in con.slice(0, 8)) {
            for (j in 0...i.length) {
                if (i.charAt(j) != "0") crates[j].insert(0, i.charAt(j));
            }
        }
        for (i in con.slice(10)) {
            i = i.replaceAll("move", "").replaceAll("from", ",").replaceAll("to", ",");
            instructions.push(i.split(",").map(item -> int(parseInt(item))));
        }
        return {crates: crates, instr: instructions};
    }

    static function solution1(crates: AAS, instructions: AAI) {
        for (i in instructions) {
            for (j in 0...i[0]) {
                crates[i[2] - 1].push(crates[i[1] - 1].pop());
            }
        }
        return [for (i in crates) i[i.length- 1]].join("");
    }

    static function solution2(crates: AAS, instructions: AAI) {
        for (i in instructions) {
            var tmp:AS = [];
            for (j in 0...i[0]) {
                tmp.push(crates[i[1] - 1].pop());
            }
            tmp.reverse();
            crates[i[2] - 1] = crates[i[2] - 1].concat(tmp);
        }
        return [for (i in crates) i[i.length- 1]].join("");
    }
}
