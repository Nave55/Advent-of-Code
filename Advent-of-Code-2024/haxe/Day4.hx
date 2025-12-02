import Tools;

using hx.strings.Strings;
using Lambda;

class Day4 {
    static final dirs: AV2 = [
        {x: -3,  y: -3}, {x: -2, y: -2}, {x: -1, y: -1}, {x: -3, y: 3}, {x: -2, y: 2}, {x: -1, y: 1}, 
        {x: 3, y: -3}, {x: 2, y: -2}, {x: 1, y: -1}, {x: 3, y: 3}, {x: 2, y: 2}, {x: 1, y: 1},
        {x: -3, y: 0}, {x: -2, y: 0}, {x: -1, y: 0}, {x: 3, y: 0}, {x: 2, y: 0}, {x: 1, y: 0},
        {x: 0, y: -3}, {x: 0, y: -2}, {x: 0, y: -1}, {x: 0, y: 3}, {x: 0, y: 2}, {x: 0, y: 1}
    ];

    static function main() {
        var con = parse_file();
        var pt1 = checkXmas(con);
        var pt2 = checkX(con);
        Sys.println('Part 1: ${pt1}\nPart 2: ${pt2}');
    }

    static inline function parse_file() {
        return [for (i in sys.io.File.getContent('input/Day4.txt').split("\r")) i.trim().toChars()];
    }

    static function checkXmas(mat: AAC) {
        final width = mat[0].length, height = mat.length;
        var ttl = 0;

        for (r_ind => r_val in mat) {
            for (c_ind => c_val in r_val) {
                if (c_val != 'X') continue;
                var str = "";
                var cnt = 0; 
                for (val in dirs) {
                    cnt++;
                    var vec = new Tup({x: r_ind, y: c_ind});
                    var loc = vec + val;
                    if (inBounds(loc, width, height)) str += fetchVal(mat, loc);
                    if (cnt % 3 == 0) {
                        str += "X";
                        if (str == "XMAS" || str == "SAMX") ttl++; 
                        str = "";
                    }
                }
            }
        }
        
        return ttl;
    }  

    static function checkX(mat: AAC) {
        var ttl = 0;
        for (r_ind => r_val in mat) {
            for (c_ind => c_val in r_val) {
                if (c_val != 'A') continue;
                var vals = nbrs(mat, {x: r_ind, y: c_ind}, diags).vals.map(item -> item.toString()).join("");
                if (["MMSS", "SSMM", "SMSM", "MSMS"].contains(vals)) ttl++;
            }
        }
    	return ttl;
    }
}
