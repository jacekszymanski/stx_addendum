package stx;

import haxe.ds.Option;

import stx.Functions.thunk;
import tink.core.Outcome;
import stx.types.Fault;
import stx.types.Tuple2;
import tink.core.Either;
import tink.core.Error;

import stx.types.*;
import stx.Upshot;
import stx.Tuples;

using stx.Arrays;
using stx.Functions;
using stx.Options;
using stx.Eithers;
using stx.Anys;


class Options {
  @:noUsing static public inline function option<T>(?v:Null<T>):Option<T>{
    return Options.create(v);
  }
  static public function ensure<T>(opt:Option<T>):T{
    return switch(opt){
      case Some(v)  : v;
      case None     : throw 'Option undefined';
    }
  }
  /**
		Produces Option.Some(t) if `t` is not null, Option.None otherwise.
	**/
  @:noUsing static public inline function create<T>(t: T): Option<T> {
    return if (t == null) None; else Some(t);
  }
  /**
		Performs `f` on the contents of `o` if o != None
	**/
  static public function map<T, S>(o: Option<T>, f: T -> S): Option<S> {
    return switch (o) {
      case None   : None;
      case Some(v): Some(f(v));
    }
  }
  /**
		Performs `f` on the contents of `o` if `o` != None
	**/
  static public function each<T>(o: Option<T>, f: T -> Void): Option<T> {
    return switch (o) {
      case None     : o;
      case Some(v)  : f(v); o;
    }
  }
  /**
		Produces the result of `f` which takes the contents of `o` as a parameter.
	**/
  static public function flatMap<T, S>(o: Option<T>, f: T -> Option<S>): Option<S> {
    return flatten(map(o, f));
  }
  /**
		Produces the contents of `o`, throwing an error if `o` is None.
	**/
  static public function val<T>(o: Option<T>): T {
    return switch (o) {
      case None   : throw Error.withData("Option is empty",IllegalOperationError);
      case Some(v): v;
    }
  }
  /**
		Produces the value of `o` if not None, the result of `thunk` otherwise.
	**/
  static public function valOrUse<T>(o: Option<T>, thunk: Thunk<T>): T {
    return switch(o) {
      case None: thunk();
      case Some(v): v;
    }
  }
  /**
		Produces the value of `o` if not None, `c` otherwise.
	**/
  static public function valOrC<T>(o: Option<T>, c: T): T {
    return Options.valOrUse(o, thunk(c));
  }
  /**
		Produces `o1` if it is Some, the result of `thunk` otherwise.
	**/
  static public function orElse<T>(o1: Option<T>, thunk: Thunk<Option<T>>): Option<T> {
    return switch (o1) {
      case None: thunk();
      
      case Some(_): o1;
    }
  }
  /**
		Produces `o1` if it is Some, `o2` otherwise.
	**/
  static public function orElseConst<T>(o1: Option<T>, o2: Option<T>): Option<T> {
    return Options.orElse(o1, o2.toThunk());
  }
  /**
		Produces true if `o` is None, false otherwise.
	**/
  static public function isEmpty<T>(o: Option<T>): Bool {
    return switch(o) {
      case None:    true;
      case Some(_): false;
    }
  }
  /**
		Produces `true` if `o` is not None, `false` otherwise.
	**/
  static public function isDefined<T>(o: Option<T>): Bool {
    return switch(o) {
      case None:    false;
      case Some(_): true;
    }
  }
	/**
		Produces an Array of length 0 if `o` is None, length 1 otherwise.
	**/
  static public function toArray<T>(o: Option<T>): Array<T> {
    return switch (o) {
      case None:    [];
      case Some(v): [v];
    }
  }
	/**
		Swallows `o1` and produces `o2`.
	**/
  static public function then<T, S>(o1: Option<T>, o2: Option<S>): Option<S> {
    return o2;
  }
  /**
		Produces the input if predicate `f` returns true, None otherwise.
	**/
  static public function filter<T>(o: Option<T>, f: T -> Bool): Option<T> {
    return switch (o) {
      case None: None;
      case Some(v): if (f(v)) o else None;
    }
  }
  /**
		Produces an Option where `o1` may contain another Option.
	**/
  static public function flatten<T>(o1: Option<Option<T>>): Option<T> {
    return switch (o1) {
      case None: None;
      case Some(o2): o2;
    }
  }
  /**
		Produces a Tuple2 of `o1` and `o2`.
	**/
  static public function zip<T, S>(o1: Option<T>, o2: Option<S>):Option<Tuple2<T,S>> {
    return switch (o1) {
      case None     : None;
      case Some(v1) : o2.map(tuple2.bind(v1));
    }
  }
  /**
		Produces the result of `f` if both `o1` and `o2` are not None.
	**/
  static public function zipWith<T, S, V>(o1: Option<T>, o2: Option<S>, f : T -> S -> V) : Option<V> {
    return switch (o1) {
      case None: None;
      case Some(v1):
				switch (o2) {
					case None : None;
					case Some(v2) : Some(f(v1, v2));
				}
    }
  }
  /**
		Produces one or other value if only one is defined, or calls `fn` on the two and returns the result
	**/
  static public function oneOrOtherOrBothWith<A>(o1:Option<A>,o2:Option<A>,fn : A -> A -> A):Option<A>{
    return switch (o1){
      case Some(v)  :
        switch (o2){
          case Some(v0)  : Some(fn(v,v0));
          case None      : Some(v);
        }
      case None     :
        switch (o2){
          case Some(v)  : Some(v);
          case None     : None;
        }
    }
  }
  /**
		Produces an Either where `o1` is on the right, or if None, the result of  `thunk`  on the left.
	**/
  static public function orEither<T, S>(o1: Option<S>, thunk: Thunk<T>): Either<T, S> {
    return switch (o1) {
      case None: Eithers.toLeft(thunk());
      case Some(v): Eithers.toRight(v);
    }
  }
  /**
		If `o1` is None, produce the result of `thunk`.
	**/
  static public function orSuccess<T>(o1:Option<Error>,thunk:Thunk<T>):Upshot<T>{
    return switch (o1) {
      case None     : Success(thunk());
      case Some(v)  : Failure(v);
    }
  }
  /**
		If `o1` is None, produce the result of `thunk`.
	**/
  static public function orFailure<T>(o1:Option<T>,thunk:Thunk<Error>):Upshot<T>{
    return switch (o1) {
      case None     : Failure(thunk());
      case Some(v)  : Success(v);
    } 
  }
  /**
		Produces an Either where `o1` is on the left, or if None, `c`.
	**/
  static public function orEitherC<T, S>(o1: Option<T>, c: S): Either<S, T> {
    return Options.orEither(o1, c.toThunk());
  }
  static public function orSuccessC<T>(o0:Option<Error>,v:T):Upshot<T>{
    return orSuccess(o0,thunk(v));
  }
  static public function orFailureC<T>(o0:Option<T>,v:Error):Upshot<T>{
    return orFailure(o0,thunk(v));
  }
  public static function toBool<T>(option : Option<T>) : Bool {
    return switch (option) {
      case Some(_): true;
      case _: false;
    }
  }
  static public function toFailChunk<A>(m:Option<Error>):Chunk<A>{
    return switch (m){
      case Some(v)  : End(v);
      case None     : Nil;
    }
  }
  static public function toChunk<A>(m:Option<A>):Chunk<A>{
    return switch (m){
      case Some(v)  : Val(v);
      case None     : Nil;
    }
  }
  static public function orFirstDefined<T>(opt:Option<T>,arr:Array<Thunk<T>>){
    return switch (opt) {
      case None     :
        arr.foldLeft(
          None,
          function(memo,next){
            return switch (memo) {
              case Some(v)  : Some(v);
              case None     : option(next());
            }
          }
        );
      case Some(v)  : Some(v);
    }
  }
  static public function orFirstDefinedC<T>(opt:Option<T>,arr:Array<T>){
    return switch (opt) {
      case None     :
        arr.foldLeft(
          None,
          function(memo,next){
            return switch (memo) {
              case Some(v)  : Some(v);
              case None     : option(next);
            }
          }
        );
      case Some(v)  : Some(v);
    } 
  }
} 
