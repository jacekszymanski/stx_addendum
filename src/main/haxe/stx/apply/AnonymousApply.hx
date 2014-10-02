package stx.apply;

import stx.ifs.Apply in IApply;
class AnonymousApply<I,O> implements IApply<I,O>{
  public function new(apply : I -> O){
    this._apply = apply;
  }
  private dynamic function _apply(v:I):O{
    return null;
  }
  public function apply(v:I):O{
    return this._apply(v);
  }
}