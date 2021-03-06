package stx;

import stx.types.Tuple2;
import stx.Tuples.*;
import stx.Options.option;
import haxe.ds.Option;
import tink.core.Either;
using stx.Errors;
import stx.type.*;
import stx.Tuples.*;
import tink.core.Error;

using stx.Arrays;
import stx.types.*;
using stx.Options;
using stx.Eithers;
using stx.Tuples;
using stx.Compose;

using stx.Chunk;

import stx.types.Chunk in TChunk;

abstract Chunk<T>(TChunk<T>) from TChunk<T> to TChunk<T>{
  public function new(v:TChunk<T>){
    this = v;
  }
  public function ensure(?err:Error):T{
    return Chunks.ensure(this,err);
  }
  public function release():Null<T>{
    return Chunks.release(this);
  }
  public function fold<A,Z>(val:T->Z,ers:Null<Error>->Z,nil:Void->Z):Z{
    return Chunks.fold(this,val,ers,nil);
  }
  public function toOptionUpshot(){
    return Chunks.toOptionUpshot(this);
  }
  public function toUpshot(){
    return Chunks.toUpshot(this);
  }
  public function map<U>(fn:T->U):Chunk<U>{
    return Chunks.map(this,fn);
  }
  public function flatMap<U>(fn:T->Chunk<U>):Chunk<U>{
    return Chunks.flatMap(this,fn);
  }
  public function recover(fn:Error -> Chunk<T> ):Chunk<T>{
    return Chunks.recover(this,fn);
  }
  public function zipWith<U,V>(chunk1:Chunk<U>,fn:T->U->V):Chunk<V>{
    return Chunks.zipWith(this,chunk1,fn);
  }
  public function zip<U>(chunk1:TChunk<U>):Chunk<Tuple2<T,U>>{
    return Chunks.zip(this,chunk1);
  }
  public function zipOptionWith<U,V>(chunk1:TChunk<U>,fn:Option<T>->Option<U>->Option<V>):Chunk<V>{
    return Chunks.zipOptionWith(this,chunk1,fn);
  }
  public function getUpshotOrC(n:T):Upshot<T>{
    return Chunks.getUpshotOrC(this,n);
  }
  public function orElseConst(v:T):Chunk<T>{
    return Chunks.orElseConst(this,v);
  }
  public function valueOption():Option<T>{
    return Chunks.valueOption(this);
  }
  public function value():Null<T>{
    return Chunks.value(this);
  }
  public function fail():Null<Error>{
    return Chunks.fail(this);
  }
  public function isDefined():Bool{
    return Chunks.isDefined(this);
  }
}
class Chunks{
  @:noUsing static public function create<A>(?c:A):TChunk<A>{
    return (c == null) ? Nil : Val(c);
  }
  /**
		Produces a `TChunk` of `Array<A>` only if all chunks are defined.
	**/
  static public function all<A>(chks:Array<TChunk<A>>,?nilFail:Error):TChunk<Array<A>>{
    return chks.foldLeft(
        Val([]),
        function(memo,next){
          return switch ([memo,next]) {
            case [Val(memo),Val(next)]  : Val(memo.add(next));
            case [Val(memo),End(e)]     : End(e);
            case [Val(v),Nil]           : nilFail == null ? Nil : End(nilFail);
            case [End(e),End(e0)]       : End(e.append(e0));
            case [End(e),Nil]           : End(e.append(nilFail));
            case [End(e),_]             : End(e);
            case _                      : nilFail == null ? Nil : End(nilFail);
          }
        }
      );
  }
  static public function ensure<A>(chk:TChunk<A>,?err:Error):A{
    return switch (chk) {
      case Val(v) : v;
      case Nil    : throw err == null ? new Error(410,'Chunk undefined') : err;
      case End(e) : throw e;
    }
  }
  static public function release<A>(chk:TChunk<A>):Null<A>{
    return switch (chk) {
      case Val(v) : v;
      case Nil    : null;
      case End(e) : throw e;
    } 
  }
  static public function fold<A,Z>(chk:TChunk<A>,val:A->Z,ers:Null<Error>->Z,nil:Void->Z):Z{
    return switch (chk) {
      case Val(v) : val(v);
      case End(e) : ers(e);
      case Nil    : nil();
    }
  }
  static public function toOptionUpshot<A>(c:TChunk<A>){
    return switch (c){
      case Nil      : Right(None);
      case Val(v)   : Right(Some(v));
      case End(err) : err == null ? Right(None) : Left(Some(err));
    }
  }
  static public function toUpshot<A>(c:TChunk<A>){
    return switch (c){
      case Nil      : Right(null);
      case Val(v)   : Right(v);
      case End(err) : Left(err);
    }
  }
  static public function map<A,B>(chunk:TChunk<A>,fn:A->B):TChunk<B>{
    return switch (chunk){
      case Nil      : Nil;
      case Val(v)   : 
        var o = fn(v);
        create(o);
      case End(err) : End(err);
    }
  }
  static public function flatten<A>(chk:TChunk<TChunk<A>>):TChunk<A>{
    return flatMap(chk,
      function(x:TChunk<A>){
        return x;
      }
    );
  }
  static public function flatMap<A,B>(chunk:TChunk<A>,fn:A->TChunk<B>):TChunk<B>{
    return switch (chunk){
      case Nil      : Nil;
      case Val(v)   : fn(v);
      case End(err) : End(err);
    }
  }
  static public function recover<A,B>(chunk:TChunk<A>,fn:Error -> TChunk<A> ):TChunk<A>{
    return switch (chunk){
      case Nil      : Nil;
      case Val(v)   : Val(v);
      case End(err) : fn(err);
    }
  }
  static public function zipWith<A,B,C>(chunk0:TChunk<A>,chunk1:TChunk<B>,fn:A->B->C):TChunk<C>{
    return switch (chunk0){
      case Nil      : Nil;
      case Val(v)   :
        switch (chunk1){
          case Nil      : Nil;
          case Val(v0)  : Chunks.create(fn(v,v0));
          case End(err) : End(err);
        }
      case End(err) :
        switch (chunk1){
          case End(err0)  : End(err.append(err0));
          default         : Nil;
        }
    }
  }
  static public function zip<A,B>(chunk0:TChunk<A>,chunk1:TChunk<B>):TChunk<Tuple2<A,B>>{
    return zipWith(chunk0,chunk1,tuple2);
  }
  static public function zipN<A>(rest:Array<TChunk<A>>):TChunk<Array<A>>{
    return rest.foldLeft(
      Val([]),
      function(memo,next){
        return switch (memo) {
          case Val(xs) : switch (next) {
            case Val(x) : Val(xs.add(x));
            case Nil    : Val(xs);
            case End(e) : End(e);
          }
          default       : memo;
        }
      }
    );
  }
  static public function zipOptionWith<A,B,C>(chunk0:TChunk<A>,chunk1:TChunk<B>,fn:Option<A>->Option<B>->Option<C>):TChunk<C>{
    return switch (chunk0){
      case Nil      :
        switch (chunk1){
          case Nil      : fn(None,None).map(Chunks.create).valOrC(Nil);
          case Val(v)   : fn(None,Some(v)).map(Chunks.create).valOrC(Nil);
          case End(err) : End(err);
        }
      case Val(v)   :
        switch (chunk1){
          case Nil      : fn(Some(v),None).map(Chunks.create).valOrC(Nil);
          case Val(v0)  : fn(Some(v),Some(v0)).map(Chunks.create).valOrC(Nil);
          case End(err) : End(err);
        }
      case End(err) :
        switch (chunk1){
          case End(err0) if(err0!=null) : End(err.append(err0));
          default                       : End(err);
        }
    }
  }
  static public function getUpshotOrC<A>(chk:TChunk<A>,n:A):Upshot<A>{
    return switch (chk){
      case Nil      : Success(n);
      case Val(v)   : Success(v);
      case End(err) : Failure(err);
    }
  }
  static public function orChunkErrC<A>(myb:Option<A>,err:Error):TChunk<A>{
    return switch (myb){
      case Some(v)  : Val(v);
      case None     : End(err);
    }
  }
  static public function orChunkNil<A>(myb:Option<A>):TChunk<A>{
    return switch (myb){
      case Some(v)  : Val(v);
      case None     : Nil;
    }
  }
  static public function asChunkEnd<A>(myb:Option<Error>):TChunk<A>{
    return switch (myb){
      case Some(v)  : End(v);
      case None     : Nil;
    }
  }
  static public function orElseConst<A>(chk:TChunk<A>,v:A):TChunk<A>{
    return switch (chk){
      case Nil      : Chunks.create(v);
      case Val(v)   : Val(v);
      case End(err) : End(err);
    }
  }
  static public function valueOption<A>(chk:TChunk<A>):Option<A>{
    return switch (chk){
      case Nil      : None;
      case Val(v)   : Some(v);
      case End(_)   : None;
    }
  }
  static public function value<A>(chk:TChunk<A>):Null<A>{
    return switch (chk){
      case Nil      : null;
      case Val(v)   : v;
      case End(_)   : null;
    }
  }
  static public function fail<A>(chk:TChunk<A>):Null<Error>{
    return switch (chk){
      case Nil      : null;
      case Val(_)   : null;
      case End(er)  : er;
    }
  }
  static public function isDefined<A>(chk:TChunk<A>):Bool{
    return fold(chk,
      Compose.pure(true),
      Compose.pure(false),
      function() return false
    );
  }
  static public function success<A>(chk:TChunk<A>,fn:A->Void):TChunk<A>{
    switch (chk) {
      case Val(v) : fn(v);
      default     : 
    }
    return chk;
  }
  static public function failure<A>(chk:TChunk<A>,fn:Null<Error>->Void):TChunk<A>{
    switch (chk) {
      case End(v) : fn(v);
      default     : 
    }
    return chk;
  }
  static public function nothing<A>(chk:TChunk<A>,fn:Void->Void):TChunk<A>{
    switch (chk) {
      case Nil    : fn();
      default     : 
    }
    return chk;
  }
}