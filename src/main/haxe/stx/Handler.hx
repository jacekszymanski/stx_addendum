package stx;

import stx.handler.*;

import stx.ifs.Sink in ISink;

@:forward abstract Sink<T>(ISink<T>) from ISink<T> to ISink<T>{
  public function new(v){
    this = v;
  }
  @:from static public function fromAnonymousSink<I>(fn:I->Void):Sink<I>{
    return new AnonymousHandler(fn);
  }
}