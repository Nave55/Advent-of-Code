import Tools;

using hx.strings.Strings;
using Lambda;

typedef MSAV2 = Map<String, Array<Vec2>>;

class Day8 {
    static var slopes: MSAV2 = [];
    static var ants: MSAV2 = [];
    static var mat: AAS = [];
    static final height: Int = 50;
    static final width: Int = 50;
    
    static function main() {
        parse_file();
        antSlopes(ants);
        var pt1 = solution();
        var pt2 = solution2();        
        Sys.println('Part 1: ${pt1}\nPart 2: ${pt2}');
    }

    static function parse_file() {
        mat = [for (i in sys.io.File.getContent('input/Day8.txt').trim().split('\r\n')) i.split("")];
        for (r_ind => r_val in mat) {
            for (c_ind => c_val in r_val) {
                if (c_val != ".") {
                    if (!ants.exists(c_val)) ants[c_val] = [];
                    ants[c_val].push({x: r_ind, y: c_ind});
                }
            }
        }
    }

    static function antSlopes(ants: MSAV2) {
        for (value in ants) {
            for (i in 0...(value.length - 1)) {
                for (j in (i+1)...value.length) {
                    var str = vecToStr(value[i]);
                    if (!slopes.exists(str)) slopes[str] = [];
                    var a = new Tup(value[i]);
                    slopes[str].push(a - value[j]);
                }
            }
        }
    }

    static function solution() {
        var ttl: Set<String> = new Set([]);

        var insertSet = (pos: Vec2, mat: AAS, symb: String, set: Set<String>) ->
            if (inBounds(pos, width, height) && fetchVal(mat, pos) != symb) {
                ttl.push(vecToStr(pos));    
            }

        for (key => value in slopes) {
            for (i in value) {
                var val = strToVec(key);
                var symb = fetchVal(mat, val);
                var tup_k = new Tup(val), tup_i = new Tup(i);
                var pos = tup_k + i;
                var neg = tup_k - (tup_i * 2);

                insertSet(pos, mat, symb, ttl);
                insertSet(neg, mat, symb, ttl);
            }
        }
        return ttl.rtrnArray().length;
    }

    static function solution2() {
        var ttl: Set<String> = new Set([]);

        var walk = (pos: Vec2, step: Tup, set: Set<String>) ->
            while (true) {
                pos = step + pos;
                (inBounds(pos, width, height)) ? ttl.push(vecToStr(pos)) : break;
            }

        for (key => value in slopes) {
            ttl.push((key));
            for (i in value) {
                var val = strToVec(key);
                var step = new Tup(i);
                walk(val, step, ttl);
                walk(val, step.neg(), ttl);
            }
        }
        return ttl.rtrnArray().length;
    }
}
