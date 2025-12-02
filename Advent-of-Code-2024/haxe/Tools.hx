import haxe.macro.Type.AnonType;
import haxe.macro.Expr;
import haxe.Int64;
import hx.strings.Char;
import Std.*;
import Math.*;

using Lambda;
using hx.strings.Strings;

typedef Vec2 = {x: Int, y: Int};
typedef AS =   Array<String>;
typedef AI =   Array<Int>;
typedef AA =   Array<Any>;
typedef AC = Array<Char>;
typedef AF =   Array<Float>;
typedef AV2 = Array<Vec2>;
typedef AI64 =  Array<Int64>;
typedef ANI =  Array<Null<Int>>;
typedef ANF =  Array<Null<Float>>;
typedef AAS =  Array<Array<String>>;
typedef AAC = Array<Array<Char>>;
typedef AAI =  Array<Array<Int>>;
typedef AAF =  Array<Array<Float>>;
typedef AAA =   Array<Array<Any>>;
typedef AANI = Array<Array<Null<Int>>>;
typedef AANF = Array<Array<Null<Float>>>;
typedef AAAS = Array<Array<Array<String>>>;
typedef AAAI = Array<Array<Array<Int>>>;
typedef AAAF = Array<Array<Array<Float>>>;
typedef AAANI = Array<Array<Array<Null<Int>>>>;
typedef MII =  Map<Int,    Int>;
typedef MSI =  Map<String, Int>;
typedef MIS =  Map<Int,    String>;
typedef MSS =  Map<String, String>;
typedef MI64 = Map<Int,    Int64>;
typedef MS64 = Map<String, Int64>;

/**
 * [String Iterator]
 
    Example:

        var str = "esbzops qjh qfo";

        for (i in new StringIterator(str, true)) {
            trace(i);       
        }

@param str String
@param lower Bool
@return String
*/

class StringIterator {
    var str: String;
    var end: Int;
    var i: Int;
  
    public inline function new(str: String, lower: Bool = false) {
        lower == true ? this.str = str.toLowerCase() : this.str = str;
        this.i = 0;
        this.end = str.length;
    }
  
    public inline function hasNext() return i < end;
    public inline function next() {
        return str.charAt(i++);
    } 
}

/**
 * [Reverse Iterator]
 
    Example:

        var arr = [1, 2, 3, 4, 5];

        for (i in new ReverseIterator(arr.length - 1, 0)) {
            trace(i);       
        }

@param a Start
@param b End
@return No return value
*/

class ReverseIterator {
    var end:Int;
    var i:Int;
  
    public inline function new(start:Int, end:Int) {
      this.i = start;
      this.end = end;
    }
  
    public inline function hasNext() return i >= end;
    public inline function next() return i--;
  }

/**
 * [Swaps two variables]
 
    Example:

        swap(a, b) -> Void

@param start The first variable
@param end The second variable
@return No return value
*/

macro function swap(a:Expr, b:Expr) {
    return macro {var v = $a; $a = $b; $b = v;};
}

/**
 * [Creates a Vec which can do multiplication oprations]
 
    Example:

        var arr1 = new Vec([1, 2, 3, 4]);

        var arr2 = [1, 2, 3, 4];

        arr1 + arr2 -> [2, 4, 6, 8]
        
@param arr An Array<T: Float>
@param arr2 An Array<T: Float>
@return An AI
*/

abstract Vec<T: Float>(Array<T>) {
    public inline function new(s: Array<T>) {
      this = s;
    }

    @:op(A + B)
    public inline function addArrs(arr: Array<T>): Array<T> {
        return [for (i in 0...arr.length) arr[i] + this[i]];
    }

    @:op(A - B)
    public inline function subArrs(arr: Array<T>): Array<T> {
        return [for (i in 0...arr.length) this[i] - arr[i]];
    }

    @:op(A * B)
    public inline function mulArrs(arr: Array<T>): Array<T> {
        return [for (i in 0...arr.length) this[i] * arr[i]];
    }

    @:op(A * B)
    public inline function mulbyScalar(num: Int): Array<T> {
        return [for (i in 0...this.length) this[i] * num];
    }
}

/**
 * [Creates a Tuple struct which can do Vec2 math]
 
    Example:

        var arr1 = new Tup({x: 1, y: 2});

        var arr2 = {x: 1, y: 2};

        arr1 + arr2 -> {2, 4}
        
@param arr An Array<T: Float>
@param arr2 An Array<T: Float>
@return An AI
*/

abstract Tup(Vec2) {
    public inline function new(s: Vec2) {
      this = s;
    }

    @:op(A + B)
    public inline function addVecs(vec: Vec2): Vec2 {
        return {x: this.x + vec.x, y: this.y + vec.y};
    }

    @:op(A - B)
    public inline function subVecs(vec: Vec2): Vec2 {
        return {x: this.x - vec.x, y: this.y - vec.y};
    }

    @:op(A * B)
    public inline function mulVecs(vec: Vec2): Vec2 {
        return {x: this.x * vec.x, y: this.y * vec.y};
    }

    @:op(A++)
    public inline function rtrnVec2(): Vec2 {
        return {x: this.x, y: this.y};
    }

    @:op(A * B)
    public inline function mulVecByScal(scalar: Int): Vec2 {
        return {x: this.x * scalar, y: this.y * scalar};
    }

    // @:op(A - B)
    // public inline function subVecs(arr: Array<T>): Array<T> {
    //     return [for (i in 0...arr.length) this[i] - arr[i]];
    // }

    // @:op(A * B)
    // public inline function mulVecs(arr: Array<T>): Array<T> {
    //     return [for (i in 0...arr.length) this[i] * arr[i]];
    // }

    // @:op(A * B)
    // public inline function mulbyScalar(num: Int): Array<T> {
    //     return [for (i in 0...this.length) this[i] * num];
    // }
}

/**
 * [Find value in AAA using an AI]
 
    Example:'

        var arr =  [[1, 2, 3], [4, 5]];

        var arr2 = [0, 0];

        arrValue(arr, arr2) -> 1

@param arr An AAA
@param arr2 An AI
@return An AI
*/

inline function arrValue<T>(arr: Array<Array<T>>, arr2: AI) {
    return arr[arr2[0]][arr2[1]];
}

enum Dirs {
    all;
    diags;
    udlr;
}

/**
 * [Get list of neighbor indices and values in a 2d array.]
 
    Example:'

        var arr =  [[1, 2, 3], [4, 5, 6], [7, 8, 9]];

        var loc = [1, 1];

        arrValue(arr, loc) -> {indices: [[0, 1], [2, 1], [1, 2], [1 ,0]], values: [2, 8, 7, 9]}

@param arr An AAA to search in
@param loc An AI location to start at
@param diagonal Boolean to indicate if you want diagonal values
@return A struct of AAI and AA
*/

function nbrs<T>(arr: Array<Array<T>>, loc: Vec2, dir: Dirs = udlr) {
    var dirs: Array<Vec2> = [];
    var loc = new Tup(loc);

    if (dir == udlr) dirs = [{x: -1, y: 0}, {x: 0, y: -1}, {x: 0, y: 1}, {x: 1, y: 0}];
    if (dir == diags) dirs = [{x: -1, y: -1}, {x: 1, y: -1}, {x: -1, y: 1}, {x: 1, y: 1}];
    if (dir == all)   dirs = [{x: -1, y: -1}, {x: -1, y: 0}, {x:-1, y: 1}, {x: 0, y: -1}, {x: 0, y: 1}, {x: 1, y: -1}, {x: 1, y: 0}, {x: 1, y: 1}];
    var indices: Array<Vec2> = [];
    var vals: Array<T> = [];
    for (i in dirs) {
        var tmp = loc + i;
        if (tmp.x != -1 && tmp.y != -1 && tmp.x != arr.length && tmp.y != arr[0].length) {
            indices.push(tmp);
            vals.push(fetchVal(arr, tmp));
        }
    }
    return {indices: indices, vals: vals};
}

/**
 * [Sums an array of Ints]
 
    Example:
        
        intSum([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]) -> 55

@param arr An AI.
@return An Int value
*/

inline function intSum(arr: AI): Int {
    return arr.fold((num: Int, ttl: Int) -> num + ttl, 0);
}

/**
 * [Sums an array of Floats]
 
    Example:
        
        floatSum([1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]) -> 55.0

@param arr An AF.
@return A Float value
*/

inline function floatSum(arr: AF): Float {
    return arr.fold((num: Float, ttl: Float) -> num + ttl, 0);
}

/**
 * [Product of an array of Ints]
 
    Example:
        
        intProd([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]) -> 3,628,800

@param arr An AI.
@return An Int value
*/

inline function intProd(arr: AI): Int {
    return arr.fold((num: Int, ttl: Int) -> num * ttl, 1);
}

/**
 * [Product of an array of Floats]
 
    Example:
        
        floatProd([1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]) -> 3,628,800

@param arr An AF.
@return A Float value
*/

inline function floatProd(arr: AF): Float {
    return arr.fold((num: Float, ttl: Float) -> num * ttl, 1);
}

/**
 * [Min value of an array]
 
    Example:
        
        minVal([1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]) -> 1.0

@param arr An AA.
@return A Float value
*/

inline function minVal(arr: AA): Float {
    var tmp: Float = arr[0];
    for (i in 1...arr.length) tmp = Math.min(tmp, arr[i]);
    return tmp;
}

/**
 * [Max value of an array]
 
    Example:
        
        maxVal([1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]) -> 10.0

@param arr An AA.
@return A Float value
*/

inline function maxVal(arr: AA): Float {
    var tmp: Float = arr[0];
    for (i in 1...arr.length) tmp = Math.max(tmp, arr[i]);
    return tmp;
}

/**
 * [Converts binary to decimal]
 
    Example:

        binaryToDecimal("01011100") -> "92"

@param str The string to be converted.
@return Returns a string representation of the decimal value.
*/

inline function binaryToDecimal(str: String): String {
    var iter = str.length - 1;
    var dec = 1, ttl = 0;
    while (iter >= 0) {
        if (str.charAt(iter) == '1') ttl += dec;
        dec *= 2;
        --iter;
    }
    return string(ttl);
}

/**
 * [Converts decimal to binary]
 
    Example:

        binaryToDecimal("92") -> "1011100"

        binaryToDecimal("92", true) -> "01011100"

@param num The Int to be converted
@param eight Boolean that insures the string has 8 values
@return Returns a string representation of the binary value.
*/

inline function decimalToBinary(num: Int, eight = false): String {    
    var strs: String = ""; 
    while (num > 0) {
        num & 1 == 1 ? strs += "1" : strs += "0";
        num >>= 1;
    }
    if (eight) for (i in 0...8 - strs.length) strs += "0";
    return strs.reverse();
}

/**
 * [Sort string alphabetically]
 
    Example:

        alpabetSort("edcba") -> "abcde"
        alphabetSort("edcba", true) -> "edcba"

@param str The string to be sorted.
@param reverse A boolean to indicate whether the string should be reversed.
@return Returns a sorted string
*/

function alphabetSort(str: String, reverse = false): String {
    var str_arr = str.split(''); 
    !reverse ? str_arr.sort((a, b) -> a.charCodeAt(0) - b.charCodeAt(0)) : str_arr.sort((a, b) -> b.charCodeAt(0) - a.charCodeAt(0));
    return str_arr.join('');
}

/**
 * Allows for the use of the '|' pipeline operator
 
    Example: 

        var arr = ['hey', 'how', 'are', 'you']; 

        var ans = new Pipe(arr)

            | (function(a:Array<String>) return a.join(' ') + "?")

            | (function(str:String) return str.charAt(0).toUpperCase() + str.substring(1))

            | (function(str:String) return str.replaceAll('you?', 'your) + ' parents doing?');

        trace(ans);

    Output: Hey how are your parents doing?
 */

abstract Pipe<T>(T) to T {
    public inline function new(s:T) {
        this = s;
    }

    @:op(A | B)
    public inline function pipe1<U>(fn:T->U):Pipe<U> {
        return new Pipe(fn(this));
    }

    @:op(A | B) 
    public inline function pipe2<A, B>(fn:T->A->B):Pipe<A->B> {
        return new Pipe(fn.bind(this));
    }

    @:op(A | B)
    public inline function pipe3<A, B, C>(fn:T->A->B->C):Pipe<A->B->C> {
        return new Pipe(fn.bind(this));
    }

    @:op(A | B)
    public inline function pipe4<A, B, C, D>(fn:T->A->B->C->D):Pipe<A->B->C->D> {
        return new Pipe(fn.bind(this));
    }

    @:op(A | B)
    public inline function pipe5<A, B, C, D, E>(fn:T->A->B->C->D->E):Pipe<A->B->C->D->E> {
        return new Pipe(fn.bind(this));
    }
    @:op(A | B)
    public inline function pipe6<A, B, C, D, E, F>(fn:T->A->B->C->D->E->F):Pipe<A->B->C->D->E->F> {
        return new Pipe(fn.bind(this));
    }
    @:op(A | B)
    public inline function pipe7<A, B, C, D, E, F, G>(fn:T->A->B->C->D->E->F->G):Pipe<A->B->C->D->E->F->G> {
        return new Pipe(fn.bind(this));
    }
    @:op(A | B)
    public inline function pipe8<A, B, C, D, E, F, G, H>(fn:T->A->B->C->D->E->F->G->H):Pipe<A->B->C->D->E->F->G->H> {
        return new Pipe(fn.bind(this));
    }
    @:op(A | B)
    public inline function pipe9<A, B, C, D, E, F, G, H, I>(fn:T->A->B->C->D->E->F->G->H->I):Pipe<A->B->C->D->E->F->G->H->I> {
        return new Pipe(fn.bind(this));
    }
    @:op(A | B)
    public inline function pipe10<A, B, C, D, E, F, G, H, I, J>(fn:T->A->B->C->D->E->F->G->H->I->J):Pipe<A->B->C->D->E->F->G->H->I->J> {
        return new Pipe(fn.bind(this));
    }
}

/**
 * Creates a set
 
    Example: 

        var set1: Set<Int> = new Set<Int>([1, 2, 3, 4, 2, 4]);

        var set2: Array<Int> = [1, 2, 5]; 

        Sys.println(set1 & set2); -> [1, 2];

        Sys.println(set1 | set2); -> [1, 2, 3, 4, 5];
 */


    
function arraysEqual<T>(arr1: Array<T>, arr2: Array<T>): Bool {
    if (arr1.length != arr2.length) {
        return false;
    }
    for (i in 0...arr1.length) {
        if (arr1[i] != arr2[i]) {
            return false;
        }
    }
    return true;
}
 
@:generic
abstract Set<T>(Array<T>) {
    public function new(set: Array<T>) {
        var tmp: Array<T> = [];
        for (i in set) {
            if (!tmp.contains(i)) tmp.push(i); 
        }
        this = tmp;
    }

    public inline function push(val: T) {
        if (this.length > 0) {}
        if (!this.contains(val)) {
            this.push(val);
        }
    } 

    public inline function remove(val: T) {
        if (this.contains(val)) this.remove(val);
    }

    public inline function contains(val: T): Bool {
        if (this.contains(val)) return true;
        return false;
    }

    @:op(A & B)
    public function intersection(sec_set: Array<T>) {
        var result: Array<T> = [];
    
        for (i in this) {
            if (sec_set.contains(i) && !result.contains(i)) {
                result.push(i);
            }
        } 
        return result;
    }

    @:op(A | B) 
    public function union(sec_set: Array<T>) {
        var result: Array<T> = [];
        var comb = this.concat(sec_set);
        
        for (i in comb) {
            if (!result.contains(i)) result.push(i);
        }
        return result;
    }

    @:op(A++)
    public inline function rtrnArray() {
        return this;
    }
}

/**
 * [Checks if a Vec2 is in bounds given a width and height]
 
    Example:
        
        inBounds({x: 5, y: 5}, 10, 10); -> true

@param vec A Vec2.
@param width A Int.
@param vec A Int.
@return A Bool
*/

function inBounds(vec: Vec2, width: Int, height: Int) {
    return (vec.x >= 0 && vec.x < height) && (vec.y >= 0 && vec.y < width);
}

/**
 * [Retrieves a position given by a Vec2 from a Matrix]
 
    Example:
        
        var mat = [[1,2,3],[4,5,6]]
        var vec: Vec2 = {x: 0, y: 0}
         fetchVal(mat, vec); -> 1

@param mat A 2d Array.
@param vec a Vec2;
@return A <T> value
*/

function fetchVal<T>(mat: Array<Array<T>>, vec: Vec2): T {
    return mat[vec.x][vec.y];
}

/**
 * [Returns a string repr of a Vec2]
 
    Example:
        
        vecToStr({x: 1, y: 1}) -> "1,1"

@param vec A Vec2.
@return A String
*/

inline function vecToStr(vec: Vec2) {
    return '${vec.x},${vec.y}';
}

inline function strToVec(str: String) {
    var tmp = str.split(',').map(item -> parseInt(item) ?? 0);
    return {x: tmp[0], y: tmp[1]};
}
