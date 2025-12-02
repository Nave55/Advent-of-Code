import Tools;

using hx.strings.Strings;
using Lambda;

class Day8 {
    static function main() {
        var arr = parsefile();
        var sol = solution(arr);
        Sys.println('Part 1: ${sol.ttl}\nPart 2: ${sol.ttl2}');
    }

    static inline function parsefile() {
        var arr = [for (i in sys.io.File.getContent('Advent Files_2021/Day8.txt').split('\n')) i.trim().split("|")];
        return [for (i in arr) [for (j in i) j.trim().split(" ")]];
    }

    static function solution(arr: AAAS) {
        var ttl = 0, ttl2 = 0;
        for (i in arr) {
            var mp: MIS = [];
            var fives_sixes: AS = [];
            for (j in i[0]) {
                j = alphabetSort(j);
                switch(j.length) {
                    case 2: mp[1] = j;
                    case 3: mp[7] = j;
                    case 4: mp[4] = j;
                    case 7: mp[8] = j;
                    default: fives_sixes.push(j); 
                 }
            }

            fives_sixes.sort((a, b) -> b.length - a.length);
            for (j in fives_sixes) {
                if (j.length == 5) {
                        if (j.containsAll(mp[1].split(''))) mp[3] = j;
                        else if (mp[6].containsAll(j.split(''))) mp[5] = j;
                        else mp[2] = j;
                } else {
                        if (!j.containsAll(mp[1].split(''))) mp[6] = j;
                        else if (j.containsAll(mp[4].split(''))) mp[9] = j;
                        else mp[0] = j;
                }
            }

            var mp2: MSI = [for (j in mp.keyValueIterator()) j.value => j.key]; 
            var tmp_ttl = "";
            for (j in i[1]) {
                if (j.length == 2 || j.length == 3 || j.length == 4 || j.length == 7) ttl += 1;
                tmp_ttl += Std.string(mp2[alphabetSort(j)]);
            }

            ttl2 += Std.parseInt(tmp_ttl);
        }
        
        return {ttl: ttl, ttl2: ttl2};
    }
}
