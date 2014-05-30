package stx;

using stx.Chunk;

import stx.Anys;

abstract Stuff<T>(Dynamic<T>) from Dynamic<T> to Dynamic<T>{
  public inline function new(v) {
    this = v == null ? {} : v;
  }

  @:arrayAccess
  public inline function set(key:Path, value:T):Void {
    Anys.set(this,key,value);
  }

  @:arrayAccess
  public inline function get(key:Path):Null<T> {
    return Anys.diveOption(this,key).fold(
      function(x){
        return x;
      },
      function(e){
        throw e; return null;
      },
      function(){
        return null;
      }
    );
  }
  public inline function has(key:Path):Bool {
    return Anys.has(this,key);
  }
  /*public inline function del(key:Path):Bool {
    return Anys.del(this,key);
  }*/
}