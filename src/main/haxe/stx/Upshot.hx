package stx;

using stx.Arrays;

import haxe.ds.Option;
import stx.types.Tuple2;
import tink.core.Outcome in TOutcome;
import tink.core.Error;

using stx.Errors;

import stx.types.Upshot in TUpshot;

abstract Upshot<T>(TUpshot<T>) from TUpshot<T> to TUpshot<T>{
  public function new(v){
    this = v;
  }
  static public function fromFail<T>(f:Error):Upshot<T>{
    return Failure(f);
  }
  public function flatMap<U>(fn:T->Upshot<U>):Upshot<U>{
    return Upshots.flatMap(this,fn);
  }
  public function map<U>(fn:T->U):Upshot<U>{
    return Upshots.map(this,fn);
  }
  @:tinkish
  public function or(fallback:Upshot<T>):Upshot<T>{
    return Upshots.or(this,fallback);
  }
  public function retry(fn:Error->Upshot<T>){
    return Upshots.retry(this,fn);
  }
  public function recover(fn:Error->T):Upshot<T>{
    return Upshots.recover(this,fn);
  }
  public function zipWith<U,V>(oc:Upshot<U>,fn:T->U->V):Upshot<V>{
    return Upshots.zipWith(this,oc,fn);
  }
  public function zip<U>(oc:Upshot<U>):Upshot<Tuple2<T,U>>{
    return Upshots.zip(this,oc);
  }
  public function toOption():Option<T>{
    return switch (this) {
      case Success(v) : Some(v);
      default         : None;
    }
  }
}
class Upshots{
  static public function fold<A,B>(o:TUpshot<A>,fn:A->B,fn0:Error->B){
    return switch (o) {
      case Success(v) : fn(v);
      case Failure(e) : fn0(e);
    }
  }
  static public function flatMap<A,B>(o:TUpshot<A>,fn:A->TUpshot<B>):TUpshot<B>{
    return switch (o) {
      case Success(success) : fn(success);
      case Failure(failure) : Failure(failure);
    }
  }
  static public function map<A,B>(o:TUpshot<A>,fn:A->B):TUpshot<B>{
    return switch (o) {
      case Success(success) : Success(fn(success));
      case Failure(failure) : Failure(failure);
    }
  }
  @:tinkish
  static public function or<A>(o:TUpshot<A>,fallback:TUpshot<A>):TUpshot<A>{
    return switch (o) {
      case Success(success) : o;
      case Failure(failure) : fallback;
    } 
  }
  static public function retry<A>(o:TUpshot<A>,fn:Error->TUpshot<A>){
    return switch (o) {
      case Success(success) : o;
      case Failure(failure) : fn(failure);
    }
  }
  static public function recover<A>(o:TUpshot<A>,fn:Error->A):TUpshot<A>{
    return switch (o) {
      case Success(success)               : o;
      case Failure(failure)               : Success(fn(failure));
    }
  }
  static public function orUse<A>(o:TUpshot<A>,fn:Error->A):A{
    return switch (o) {
      case Success(success)               : success;
      case Failure(failure)               : fn(failure);
    } 
  }
  static public function flatten<A>(o:TUpshot<TUpshot<A>>):TUpshot<A>{
    return switch (o) {
      case Success(Success(success))      : Success(success);
      case Success(Failure(failure))      : Failure(failure);
      case Failure(failure)               : Failure(failure);
    }
  }
  static public function zipWith<A,B,C>(o:TUpshot<A>,o0:TUpshot<B>,fn:A->B->C):TUpshot<C>{
    return switch ([o,o0]) {
      case [Success(v0),Success(v1)]      : Success(fn(v0,v1));
      case [Failure(err),Success(_)]      : Failure(err);
      case [Success(v0),Failure(err)]     : Failure(err);
      case [Failure(err0),Failure(err1)]  : Failure(Errors.append(err0,err1));
    }
  }
  static public function zip<A,B>(o:TUpshot<A>,o0:TUpshot<B>):TUpshot<Tuple2<A,B>>{
    return zipWith(o,o0,tuple2);
  }
  static public function isFailure<A>(o:TUpshot<A>):Bool{
    return switch (o) {
      case Success(_) : false;
      case Failure(_) : true;
    }
  }
  static public function isSuccess<A>(o:TUpshot<A>):Bool{
    return switch (o) {
      case Success(_) : true;
      case Failure(_) : false; 
    }
  }
  static public function toChunk<A>(oc:Upshot<A>):Chunk<A>{
    return switch (oc){
      case Failure(l)  : End(l);
      case Success(r)  : r == null ? Nil : Val(r);
    }
  }
  static public function onSuccess<A>(oc:Upshot<A>,fn:A->Void):Upshot<A>{
    switch (oc) {
      default         : 
      case Success(a) : fn(a);
    }
    return oc;
  }
  static public function onFailure<A>(oc:Upshot<A>,fn:Error->Void):Upshot<A>{
    switch (oc) {
      default         : 
      case Failure(f) : fn(f);
    }
    return oc;
  }
  static public function orErrors<A>(a:Array<Upshot<A>>):Upshot<Array<A>>{
    return a.foldLeft(
      Success([]),
      function(memo:Upshot<Array<A>>,next:Upshot<A>):Upshot<Array<A>>{
        return switch ([memo,next]) {
          case [Success(v0),Success(v1)]  : Success(v0.add(v1)); 
          case [Failure(e0),Failure(e1)]  : Failure(e0.append(e1));
          case [Success(v),Failure(e)]    : Failure(e);
          case [Failure(e),Success(v)]    : Failure(e);
        }
      }
    );
  }
}