import haxe.macro.Expr;
import haxe.Int64;
import Std.*;
using Lambda;
using hx.strings.Strings;

typedef AS = Array<String>;
typedef AI = Array<Int>;
typedef AF = Array<Float>;
typedef AAS = Array<Array<String>>;
typedef AAI = Array<Array<Int>>;
typedef AAF = Array<Array<Float>>;
typedef AAAS = Array<Array<Array<String>>>;
typedef AAAI = Array<Array<Array<Int>>>;
typedef AAAF = Array<Array<Array<Float>>>;
typedef MII = Map<Int,Int>;
typedef MSI = Map<String,Int>;
typedef MIS = Map<Int,String>;
typedef MSS = Map<String,String>;
typedef MI64 = Map<Int, Int64>;
typedef MS64 = Map<String,Int64>;

macro function swap(a:Expr, b:Expr) {
    return macro {var v = $a; $a = $b; $b = v;};
}

inline function intSum(arr: Array<Int>):Int {
    var ttl = 0;
    for (i in arr) ttl += i;
    return ttl;
}

inline function floatSum(arr: Array<Float>):Float {
    var ttl:Float = 0;
    for (i in arr) ttl += i;
    return ttl;
}

inline function intProd(arr: Array<Int>): Int {
    var ttl = 1;
    for (i in arr) ttl *= i;
    return ttl;
}

inline function floatProd(arr: Array<Float>): Float {
    var ttl:Float = 1.0;
    for (i in arr) ttl *= i;
    return ttl;
}

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

inline function decimalToBinary(num: Int): String {    
    var strs: String = ""; 
    while (num > 0) {
        if (num & 1 == 1) strs += "1";
        else strs += "0";
        num >>= 1;
    }
    return strs.reverse();
}

/**
 * [Sort string alphabetically] 
 * - Ex: "edcba" -> "abcde"
 * @param str
 * @return String
 */

inline function alphabetSort(str: String): String {
    var arr: AI = [];
    var sort_str = "";
    for (i in 0...str.length) arr.push(str.charCodeAt(i));
    arr.sort((a,b) -> a - b);
    for (i in arr) sort_str += i.toChar();
    return sort_str;
}

/**
 * [Allows for the use of the '|' pipeline operator]
 
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
