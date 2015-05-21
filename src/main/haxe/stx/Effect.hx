package stx;

import stx.effect.AnonymousEffect;

import stx.ifs.Effect in IEffect;

@:forward abstract Effect(IEffect) from IEffect to IEffect{
  public function new(v){
    this = v;
  }
  @:from static public function fromThunk(fn:Void->Void):Effect{
    return new AnonymousEffect(fn);
  }
}