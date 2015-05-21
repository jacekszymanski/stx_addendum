package stx.sink;

import stx.ifs.Sink in ISink;

class AnonymousSink<T>{
  public function new(fn){
    this._apply = fn;
  }
  public dynamic function _apply(v:T):Void{

  }
  public function apply(v:T):Void{
    this._apply(v);
  }
}