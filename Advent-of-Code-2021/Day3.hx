import StringTools.*;
import Std.*;
import Math.*;

using hx.strings.Strings;

class Day3 {
    static var first_dig_g = 0;
    static var first_dig_e = 0;
    static function main() {
        var con = [for (i in sys.io.File.getContent('Advent Files_2021/Day3.txt').split('\n')) trim(i)]; 
        Sys.println('Part 1: ${part1(con)}\nPart 2: ${part2(con)}');
    }

    static inline function part1(arr:Array<String>):Int {
        var gamma_rate:Array<Int> = [], epsilon_rate:Array<Int> = [];
        var dec_g = 0, dec_e = 0, dec = 1, dec1 = 1;

        for (i in 0...12) {
            if (arr.filter(item -> item.charAt(i) == '1').length > 
                arr.filter(item -> item.charAt(i) == '0').length) {
                    gamma_rate.insert(0,1);
                    epsilon_rate.insert(0,0);
            }
            else {
                gamma_rate.insert(0,0);
                epsilon_rate.insert(0,1);
            }
        }
        for (i in 0...12) {
            if (gamma_rate[i] == 1) dec_g += dec;
            if (epsilon_rate[i] == 1) dec_e += dec1;
            dec *= 2;
            dec1 *= 2;
        }

        first_dig_g = gamma_rate[11];
        first_dig_e = epsilon_rate[11];

        return dec_e * dec_g;
    }

    static inline function part2(arr:Array<String>):Int {
        var o_ratings:Array<String> = [], co2_ratings:Array<String> = [];
        o_ratings = arr.filter(item -> item.charAt(0) == string(first_dig_g));
        co2_ratings = arr.filter(item -> item.charAt(0) == string(first_dig_e));
        var dec_o = 0, dec_co2 = 0, dec = 1, dec1 = 1;

        for (i in 1...12) {
            if (o_ratings.length > 1) { 
                if (o_ratings.filter(item -> item.charAt(i) == '1').length >= 
                    o_ratings.filter(item -> item.charAt(i) == '0').length) { 
                        o_ratings = o_ratings.filter(item -> item.charAt(i) == '1');
                }
                else o_ratings = o_ratings.filter(item -> item.charAt(i) == '0');
            }
            if (co2_ratings.length > 1) { 
                if (co2_ratings.filter(item -> item.charAt(i) == '1').length < 
                    co2_ratings.filter(item -> item.charAt(i) == '0').length) { 
                        co2_ratings = co2_ratings.filter(item -> item.charAt(i) == '1');
                }
                else co2_ratings = co2_ratings.filter(item -> item.charAt(i) == '0');
            }
        }
        o_ratings = o_ratings[0].split('');
        o_ratings.reverse();
        co2_ratings = co2_ratings[0].split('');
        co2_ratings.reverse();

        for (i in 0...12) {
            if (o_ratings[i] == '1') dec_o += dec;
            if (co2_ratings[i] == '1') dec_co2 += dec1;
            dec *= 2;
            dec1 *= 2;
        }

        return dec_co2 * dec_o;
    }
}