import StringTools.*;
import Std.*;
import Tools;
import Math.*;

using hx.strings.Strings;

class Day2_2023 {
    static function main() {
        var data = parsefile();
        solution(data);
    }

    static inline function parsefile() {
        var con: AS = [for (i in sys.io.File.getContent('Advent Files_2023/Day2.txt').split('\n')) trim(i)];
        con = [for (i in con) i.split(':')[1]];
        var con: AAS = [for (i in con) trim(i).split(';')];
        var data:AAAS = [];
        for (i in con) {
            var tmp:AAS = [];
            for (j in i) {
                tmp.push(trim(j).replaceAll(',','').split(' '));
            }
            data.push(tmp);
        }
        return data;
    }

    static function solution(data: AAAS) { 
        var ttl = 0, ttl2 = 0;
        for (base_ind => base_val in data) {
            var sizes = ["green" => 1, "blue"=> 1, "red"=> 1];
            var tmp = 0;
            for (j in base_val) {
                var mp = ["green" => 0, "blue"=> 0, "red"=> 0];
                for (ind => val in j) {
                    if (ind & 1 == 1) mp[val] += parseInt(j[ind-1]);
                }
                if (mp['red'] > 12 || mp['green'] > 13 || mp['blue'] > 14) tmp++;
                sizes['green'] = int(max(sizes['green'], mp['green']));
                sizes['red'] = int(max(sizes['red'], mp['red']));
                sizes['blue'] = int(max(sizes['blue'], mp['blue'])); 
            }
            if (tmp == 0) ttl += base_ind+1;
            ttl2 += (sizes['green'] * sizes['red'] * sizes['blue']);
        }
        trace('\nPart 1: $ttl\nPart 2: $ttl2');
    }
}
