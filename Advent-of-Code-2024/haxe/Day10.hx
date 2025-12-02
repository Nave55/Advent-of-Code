import Tools;
import Std.*;

using hx.strings.Strings;
using Lambda;

class Day10 {
    static function main() {
        var con = parse_file();
        var sol = solution(con);
        Sys.println('Part 1: ${sol.pt1}\nPart 2: ${sol.pt2}');
    }

    static inline function parse_file() {
        return [for (i in sys.io.File.getContent('input/Day10.txt').splitLines()) i.split("").map(item -> parseInt(item) ?? 0)];
    }

    static function bfs(mat: AAI, pos: Vec2, visited: Set<String>, target: Int = 9): Int {
        var result = 0;
        var localVisited = new Set<String>([]);
        var queue: Array<Vec2> = [];
        queue.push(pos);
        visited.push(vecToStr(pos));
        localVisited.push(vecToStr(pos));

        while (queue.length > 0) {
            var current: Vec2 = queue.pop();
            if (fetchVal(mat, current) == target) result++;

            var vals = nbrs(mat, current);
            for (ind => val in vals.indices) {
                if (vals.vals[ind] == fetchVal(mat, current) + 1 && !localVisited.contains(vecToStr(val))) {
                    queue.push(val);
                    localVisited.push(vecToStr(val));
                    visited.push(vecToStr(val));
                }
            }
        }
        return result;
    }

    static function dfs(mat: AAI, pos: Vec2, visited: Set<String>, target: Int = 9) {
        var result = 0;
        if (fetchVal(mat, pos) == target) return 1;

        visited.push(vecToStr(pos));
        var vals = nbrs(mat, pos);
        for (neighbor in vals.indices) { 
            if (!visited.contains(vecToStr(neighbor)) && fetchVal(mat, neighbor) ==  fetchVal(mat, pos) + 1) {
                result += dfs(mat, neighbor, visited);
            }
            visited.remove(vecToStr(pos));
        }

        return result; 
    }

    static function solution(mat: AAI) {
        var pt1 = 0, pt2 = 0;
        var pt1_visited = new Set<String>([]);
        var pt2_visited = new Set<String>([]);

        for (r_ind => r_val in mat) {
            for (c_ind => c_val in r_val) {
                if (c_val == 0) {
                    var tmp: Vec2 = {x: r_ind, y: c_ind};
                    if (!pt1_visited.contains(vecToStr(tmp))) pt1 += bfs(mat, tmp, pt1_visited);
                    pt2 += dfs(mat, tmp, pt2_visited);
                }
            }
        } 

        return {pt1: pt1, pt2: pt2};
    }
}