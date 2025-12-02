import StringTools.*;
import Std.*;
import Tools;
import haxe.ds.Vector;
import haxe.ds.StringMap;

using hx.strings.Strings;
using Lambda;

typedef VVS = Vector<Vector<String>>;

class Day6 {
    static var dirs: Array<Vec2> = [{x: -1, y: 0}, {x: 0, y: 1}, {x: 1, y: 0}, {x: 0, y: -1}];
    static var rows = 130;
    static var cols = 130;
    
    static function main() {
        var con = parse_file();
        var s1 = solution(con.mat, con.start);
        var s2 = solution2(con.mat, con.start, con.locs, s1);
        Sys.println('Part 1: ${s1.count()}\nPart 2: ${s2}');
    }

    static function parse_file() {
        var con: Vector<Vector<String>> = new Vector(rows);
        for (r_ind => r_val in sys.io.File.getContent('input/Day6.txt').split("\r\n")) {
            con[r_ind] = new Vector(cols);
            for (c_ind in 0...cols) {
                con[r_ind][c_ind] = r_val.charAt(c_ind);
            } 
        }

        var start: Vec2 = {x: 0, y: 0};
        var locs: Map<String, Int> = [];  

        for (r_ind in 0...rows) {
            for (c_ind in 0...cols) {
                var val = {x: r_ind, y: c_ind};
                if (con[r_ind][c_ind] == "^") start = val;
                if (con[r_ind][c_ind] == "#") locs[vecToStr(val)] = 0;
            }
        }
        return {mat: con, start: start, locs: locs}
    }

    static inline function inbounds(pos: Vec2) {
        return (pos.x > 0 && pos.x < rows - 1) && (pos.y > 0 && pos.y < cols - 1);
    }

    static function solution(mat: VVS, start: Vec2) {
        var facing = 0;
        var pos = start;
        var visited: StringMap<Bool> = new StringMap();

        while (inbounds(pos)) {
            var v_pos = new Tup(pos);
            var next_pos = v_pos + dirs[facing];
            if (mat[next_pos.x][next_pos.y] == "#") {
                facing++;
                facing = facing & 3;
            } else {
                visited.set(vecToStr({x: pos.x, y: pos.y}), true);
                pos = next_pos;
            }
        }
        visited.set(vecToStr({x: pos.x, y: pos.y}), true);

        return visited;
    }

    static function solution2(mat: VVS, start: Vec2, locs: Map<String, Int>, empty: StringMap<Bool>) {
        var ttl = 0;

        for (i in empty.keys()) {
            var i_vec = strToVec(i);
            var facing = 0;
            var pos = start;
            mat[i_vec.x][i_vec.y] = "#";
            locs[i] = 0;

            while (inbounds(pos)) {
                var v_pos = new Tup(pos); 
                var next_pos = v_pos + dirs[facing];
                if (mat[next_pos.x][next_pos.y] == "#") {
                    facing++;
                    locs[vecToStr(next_pos)]++;
                    if (locs[vecToStr(next_pos)] == 4) {
                        // trace('Obstacle was at pos ${i[0]},${i[1]}');
                        ttl++;
                        break;
                    }
                    facing = facing & 3;
                } else pos = next_pos;
            }
            mat[i_vec.x][i_vec.y] = '.';
            for (key in locs.keys()) locs[key] = 0;
            locs.remove(i);
        }

        return ttl;
    }
}
