package stx;

class Callbacks{
  static public inline function and<A>(c0:Callback<A>,c1:Callback<A>):Callback<A>{
    return function(v:A):Void{
      c0.invoke(v);
      c1.invoke(v);
    }
  }
}