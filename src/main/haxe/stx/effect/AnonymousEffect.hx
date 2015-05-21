package stx.effect;

import stx.ifs.Effect in IEffect;

class AnonymousEffect implements IEffect{

  public function new(unsubscribe){
    this._run = unsubscribe;
  }
  private dynamic function _run(){

  }
  public function run(){
    this._run();
  }
}