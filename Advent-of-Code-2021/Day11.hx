import Std.*;
import Tools;

using hx.strings.Strings;

class Day11 {
    static function main() {
        var con = parseFile("input/day11.txt");
        var pt1 = solution(con);
        var pt2 = solution2(con);
        Sys.println('Part 1: ${pt1}\nPart 2: ${pt2}');
    }

    static function parseFile(path: String) { 
        return 
            [for (i in sys.io.File.getContent(path).split('\r\n')) 
                [for (j in new StringIterator(i)) parseInt(j) ?? 0]
            ];
    }

    static function setZero(con: AAI) {
        for (r_ind => r_val in con) {
            for (c_ind => c_val in r_val) {
                if (c_val > 9) con[r_ind][c_ind] = 0;
            }
        }
    }

    static function step(con: AAI) {
        for (r_ind => r_val in con) {
            for (c_ind => c_val in r_val) con[r_ind][c_ind]++;
        }
    }

    static function flash(con: AAI, has_flashed: Map<String, {}>, ttl: Int): Int {
        var flash_amt = ttl;
        var new_flashes: Array<Vec2> = [];

        for (r => row in con) {
            for (c => v in row) {
                var key = r + "," + c;
                if (v > 9 && !has_flashed.exists(key)) {
                    has_flashed[key] = {};
                    new_flashes.push({x: r, y: c});
                    flash_amt++;
                }
            }
        }

        if (new_flashes.length == 0) {
            setZero(con);
            return flash_amt;
        }

        for (pos in new_flashes) {
            var n = nbrs(con, pos, all);
            for (j in n.indices) con[j.x][j.y]++;
        }

        return flash(con, has_flashed, flash_amt);
    }

    static function allZeroes(con: AAI) {
        for (i in con) {
            for (j in i) if (j != 0) return false;
        }

        return true;
    }

    static function solution(con: AAI) {
        var sol = 0;
        for (i in 1 ... 101) {
            step(con);
            sol += flash(con, [], 0);
        }
        
        return sol;
    } 
    
    static function solution2(con: AAI) {
        var ind = 101;

        while (true) {
            step(con);
            flash(con, [], 0);
            if (allZeroes(con)) return ind;
            ind++;
        }
    }
}
