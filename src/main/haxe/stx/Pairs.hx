package stx;

import tink.core.Pair;

class Pairs{
  static public function fst<A,B>(pr:Pair<A,B>):A{
    return pr.a;
  }
  static public function snd<A,B>(pr:Pair<A,B>):B{
    return pr.b;
  }
  static inline public function into<A,B,C>(t:Pair<A,B>,f:A->B->C):C {
    return f(t.a,t.b);
  }
  public inline static function paired<A,B,C>(f : A -> B -> C){
    return into.bind(_,f);
  }
}
