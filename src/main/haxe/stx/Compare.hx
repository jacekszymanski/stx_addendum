package stx;

import stx.types.Predicate in TPredicate;

import stx.types.*;

import stx.Method;
import stx.Equal;
import stx.Order;

using stx.Strings;
using stx.Functions;
using stx.Iterables;
using stx.Maths;
using stx.Compose;

/**		
  This is a good class to use in conjuncture with stx.UnitTest, stx.test.Assert and filters.

  ```
  import stx.Compare;.*;
  
  arr.filter(eq(3)) // produces predicate that returns true if input equals 3.
  ```
  nice.

  Unlikely to screw with other global namespace stuff, but keep an eye on it.
**/
class Compare{
  /**
		Predicator for value v.
	**/
  @:noUsing static public inline function compare<T>(v:T){
    return new Predicator(v);
  }
  /**
		Always returns true, no matter the input.
	**/
  @:noUsing static public inline function always<T>():Predicate<T>{
    return function(value:T){return true;}
  }
  /**
		Always returns false, no matter the input.
	**/
  @:noUsing static public inline function never<T>():Predicate<T>{
    return function(value:T){return false;}
  }
  /**
		Bools.isTrue
	**/
  @:noUsing static public inline function ok():Predicate<Bool>{
    return function(value:Bool){return value;}
  }
  /**
		Bools.isFalse
	**/
  @:noUsing static public inline function no():Predicate<Bool>{
    return function(value:Bool){return !value;}
  }
  @:noUsing static public inline function is<A>(cls:Class<A>):Predicate<A>{
    return Std.is.bind(_,cls);
  }
  @:noUsing static public inline function throws<A>(?type:Class<Dynamic>):Predicate<Void->Void>{
    return function(fn:Void->Void):Bool{
      var er = null;
      try{ 
        fn();
      }catch(e:Dynamic){ 
        er = e; 
      }
      return !(er == null) && (type != null ? Std.is(er,type) : true);
    }
  }
  /**
		null-check
	**/
  @:noUsing static public inline function nl<T>():stx.Predicate<T>{
    return function(value:T) {return value == null;}
  }
  /**
		not-null-check
	**/
  @:noUsing static public inline function ntnl<T>():stx.Predicate<T>{
    return function(value:T) {return value != null;}
  }
  @:noUsing static public inline function alike(e:EnumValue):stx.Predicate<EnumValue>{
    return stx.Enums.alike.bind(e);
  }
  @:noUsing static public inline function matches(reg:EReg):stx.Predicate<String>{
    return function(str:String){return reg.match(str);}
  }
  /**
		equals
	**/
  @:noUsing static public inline function eq<T>(p:T):stx.Predicate<T>{
    return Equal.getEqualFor(p).bind(p);
  }
  /**
		greater than
	**/
  @:noUsing static public inline function gt<T>(p:T):stx.Predicate<T>{
    return Order.getOrderFor(p).bind(p).then(Ints.eq.bind(1));
  }
  /**
		greater than or equal
	**/
  @:noUsing static public inline function gteq<T>(p:T):stx.Predicate<T>{
    return Order.getOrderFor(p).bind(p).then(Ints.gteq.bind(0));
  }
  /**
		less than
	**/
  @:noUsing static public inline function lt<T>(p:T):stx.Predicate<T>{
    return Order.getOrderFor(p).bind(p).then(Ints.eq.bind(-1));
  }
  /**
		less than or equal
	**/
  @:noUsing static public inline function lteq<T>(p:T):stx.Predicate<T>{
    return Order.getOrderFor(p).bind(p).then(Ints.lteq.bind(0));
  }
}