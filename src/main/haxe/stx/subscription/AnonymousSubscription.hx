package stx.subscription;

import stx.ifs.Subscription in ISubscription;

class AnonymousSubscription implements ISubscription{

  public function new(unsubscribe){
    this._unsubscribe = unsubscribe;
  }
  private dynamic function _unsubscribe(){

  }
  public function unsubscribe(){
    this._unsubscribe();
  }
}