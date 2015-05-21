package stx;

import stx.types.Homo;

@:callable abstract Reduced<T>(Homo<T>) from Homo<T>{
  public function fromT<T>(v:T){
    return function(x){
      return v;
    }
  }  
}