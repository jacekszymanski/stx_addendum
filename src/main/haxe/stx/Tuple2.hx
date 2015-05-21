package stx;

#if scuts_core
  import scuts.core.Tuples;
#end

import stx.types.Tuple3;
import stx.Tuples;
import tink.core.Pair;
import stx.Equal;
import stx.types.Tuple2 in TTuple2;

@:callable abstract Tuple2<A,B>(TTuple2<A,B>) from TTuple2<A,B> to TTuple2<A,B>{
  public function new(l,r){
    this = tuple2(l,r);
  }
  #if scuts_core
    @:from static public function fromTup2<A,B>(tup2:Tup2<A,B>):Tuple2<A,B>{
      return new Tuple2(tup2._1,tup2._2);
    }
  @:to public function toTup2():Tup2<A,B>{
    return scuts.core.Tuples.tup2(fst(),snd());
  }
  #end

  @:from static public function fromPair<A,B>(pair:Pair<A,B>):Tuple2<A,B>{
    return new Tuple2(pair.a,pair.b);
  }
  @:to public function toPair():Pair<A,B>{
    return new Pair(fst(),snd());
  }
  public function fst() : A {
    return switch (this){
        case tuple2(a,_)    : a;
    }
  }
  public function snd() : B {
    return switch (this){
      case tuple2(_,b)    : b;
    }
  }
  public function swap() : Tuple2<B, A> {
    return switch (this) {
      case tuple2(a, b): new Tuple2(b, a);
    }
  }
  public function equals(b : Tuple2<A,B>): Bool {
    var a = this;
    return switch (a) { 
      case tuple2(t1_0, t2_0):
        switch (b) {
            case tuple2(t1fst, t2fst): Equal.getEqualFor(t1_0)(t1_0,t1fst) && Equal.getEqualFor(t2_0)(t2_0,t2fst);
        }
    }
  }
  public function toString() : String {
    return '${Show.show(fst())}${Show.show(snd())}';
  }
  public function toArray() : Array<Dynamic> {
    return switch (this){
      case tuple2(a,b)    : [a,b];
    }
  }
  public function toProduct<A,B>() : Product{
      return new Product(toArray());
  }
  public inline function entuple<C>(c:C): Tuple3<A, B, C> {
    return tuple3(fst(), snd(), c);
  }
  public function into<C>(f:A->B->C):C {
    return switch(this){
      case tuple2(a,b)    : f(a,b);
    }
  }
  public inline static function tupled<A,B,C>(f : A -> B -> C){
    return Tuples.Tuples2.into.bind(_,f);
  }
  public inline static function untupled<A,B,C>(f:Tuple2<A,B>->C):A->B->C{
    return function(a:A,b:B):C{
      return f(tuple2(a,b));
    }
  }
}