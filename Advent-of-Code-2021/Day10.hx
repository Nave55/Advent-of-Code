import haxe.Int64;
import haxe.ds.GenericStack;
import StringTools.*;
import Tools;

using hx.strings.Strings;
using Lambda;

class Day10 {
    static function main() {
        var con = parseFile();
        var sol = syntax(con);
        Sys.println('Part 1: ${sol.ttl}\nPart 2: ${sol.ttl2}');
    }

    static inline function parseFile() {
        var con: AS = [for (i in sys.io.File.getContent('Advent Files_2021/Day10.txt').split('\n')) trim(i)];
        return con;
    }

    static function syntax(con: AS) {
        var valid = ["[", "{", "<", "("];
        var mp: Map<String, String> = ["]" => "[", "}" => "{", ")" => "(", ">" => "<", 
                                       "[" => "]", "{" => "}", "(" => ")", "<" => ">"];
        var scorer: Map<String, Int> =  [")" => 3, "]" => 57, "}" => 1197, ">" => 25137];
        var scorer2: Map<String, Int> = [")" => 1, "]" => 2, "}" => 3, ">" => 4];
        var ttl = 0;
        var ttl2: AI64 = [];
        
        for (i in con) {
            var b = new GenericStack<String>();
            for (j in i.split("")) {
                if (valid.contains(j)) b.add(j);
                else if (mp[j] == b.first()) b.pop();
                else {
                    ttl += scorer[j];
                    b.add("Corrupt");
                    break;
                }
            }
            if (b.first() != "Corrupt") {
                var tmp: Int64 = 0;
                for (j in b) {
                    tmp *= 5;
                    tmp += scorer2[mp[j]];
                }
                ttl2.push(tmp);
            }
        }

        ttl2.sort((a, b) -> Int64.compare(a, b));
        return {ttl: ttl, ttl2: ttl2[Std.int(ttl2.length / 2)]};
    }
}
