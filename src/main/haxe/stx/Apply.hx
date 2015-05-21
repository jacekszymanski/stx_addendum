package stx;

import stx.apply.AnonymousApply;
import stx.ifs.Apply in IApply;

@:callable @:forward abstract Apply<I,O>(IApply<I,O>) from IApply<I,O> to IApply<I,O>{
  public function new(v){
    this = v;
  }
  @:from static public function fromAnonymousApply<I,O>(fn:I->O):Apply<I,O>{
    return new AnonymousApply(fn);
  }
}
