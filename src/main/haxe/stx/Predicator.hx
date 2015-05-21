package stx;

import stx.types.*;

import stx.Method;
import stx.Equal;
import stx.Order;

using stx.Strings;
using stx.Functions;
using stx.Iterables;
using stx.Maths;
using stx.Compose;

/**
  Caches function lookup for value.
**/
class Predicator<T>{
  private var __eq__ : Eq<T>;
  private var __od__ : Ord<T>;
  private var __dt__ : T;

  public function new(v:T){
    __dt__ = v;
  }
  public inline function eq():Predicate<T>{
    return _eq().bind(__dt__);
  }
  public inline function gt():Predicate<T>{
    return _od().bind(__dt__).then(Ints.eq.bind(1));
  }
  public inline function gteq():Predicate<T>{
    return _od().bind(__dt__).then(Ints.gteq.bind(0));
  }
  public inline function lt():Predicate<T>{
    return _od().bind(__dt__).then(Ints.eq.bind(-1));
  }
  public inline function lteq():Predicate<T>{
    return _od().bind(__dt__).then(Ints.lteq.bind(0));
  }
  private inline function _eq(){
    return this.__eq__ = __eq__ == null ? Equal.getEqualFor(__dt__) : __eq__;
  }
  private inline function _od(){
    return this.__od__ = __od__ == null ? Order.getOrderFor(__dt__) : __od__;
  }
}