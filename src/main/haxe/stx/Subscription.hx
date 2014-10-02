package stx;

import stx.subscription.AnonymousSubscription;

import stx.ifs.Subscription in ISubscription;

@:forward abstract Subscription(ISubscription) from ISubscription to ISubscription{
  public function new(v){
    this = v;
  }
  @:from static public function fromAnonymousSubscription(fn:Void->Void):Subscription{
    return new AnonymousSubscription(fn);
  }
}