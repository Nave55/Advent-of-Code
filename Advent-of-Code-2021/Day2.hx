import StringTools.*;
import Std.*;
import Math.*;

class Day2 {
    static function main() {
        var con = [for (i in sys.io.File.getContent('Advent Files_2021/Day2.txt').split('\n')) trim(i)];
        var horizontal = 0, depth = 0, horizontal1 = 0, depth1 = 0, aim = 0; 
        for (i in con) {
            switch (i.charAt(0)) {
                case 'f': 
                    horizontal += parseInt(i.substr("forward".length + 1));
                    horizontal1 += parseInt(i.substr("forward".length + 1));
                    depth1 += aim * parseInt(i.substr("forward".length + 1));
                case 'd': 
                    depth += parseInt(i.substr("down".length + 1));
                    aim += parseInt(i.substr("down".length + 1));
                case 'u': 
                    depth -= parseInt(i.substr("up".length + 1));
                    aim -= parseInt(i.substr("up".length + 1));
            }
        }
        Sys.println('Part 1: ${horizontal * depth}\nPart 2: ${horizontal1 * depth1}');
    }
}