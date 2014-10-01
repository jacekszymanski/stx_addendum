package stx;

import stx.types.Fault;
import stx.Order;
import stx.Options;

using stx.Pairs;
using tink.core.Outcome;
using stx.Strings;
using stx.Tuples;
using stx.Iterables;
using stx.Types;
using stx.Functions;
using stx.Chunk;
using stx.Options;
using stx.Compose;

import stx.types.Tuple2;
import tink.core.Error;
using stx.Arrays;

import stx.types.Fault;
import stx.Chunk;
import tink.core.Either;
import stx.types.*;
import stx.Eithers;
import stx.Compare;

using stx.Options;

typedef Any = Dynamic;

class Anys {
	/**
	  Takes a value, applies a Function1 to the value and returns the original value.
	  @param 	a			Any value.
	  @param 	f			Modifier function.
	  @return 	a			The input value after f(a).
	 */
  static public function affect<T>(t: T, f: T->Void): T {
    f(t);
    
    return t;
  }
	
	/**
	  Returns a Thunk that will always return the input value t.
	  @param 		t		Any value
	  @return 				A function that will return the input value t.
	 */
  static public function toThunk<T>(t: T): Thunk<T> {
    return function() {
      return t;
    }
  }  
  /**
    Applies a function 'f' to a valuse of any Type.
  */
  static public function use<A,B>(v:A,fn:A->Void):Void{
  	fn(v);
  }
  /**
    Applies Function1 f to value a and returns the result.
    @param      a     Any value.
    @param      f     Modifier function.
    @usage a.into( function(x) return ... )
   */
  static public function to<A, B>(a: A, f: A -> B): B {
    return f(a);
  }
  /**
    Drops value a, returns b
  */
  static public function exchange<A,B>(a:A,b:B):B{
  	return b;
  }
  /**
    Check if ´v´ is null, returns result of ´fn´ if not.
  */
  static public function orIfNull<A>(v:A,fn:Thunk<A>):A{
    return Options.create(v).valOrUse(fn);
  }
  public static function equals<T1, T2>(value0 : T1, value1 : T2, ?func : T1 -> T2 -> Bool ) : Bool {
    if (func == null) {
      func = function(a, b) {
          var type0 = Type.typeof(a);
          var type1 = Type.typeof(b);
          if (Type.enumEq(type0, type1)) {
              return switch(type0) {
                  case TEnum(_) : 
                  var _a : EnumValue = cast a;
                  var _b : EnumValue = cast b;
                  Type.enumEq(_a,_b);
                  case _: cast a == cast b;
              }
          }
          return false;
      };
    }
    return func(value0, value1);
  }

    public static function getName<T>(value : T)  : String {
        return switch(Type.typeof(value)) {
            case TUnknown   : 'unknown';
            case TObject    : try Type.getClassName(cast value) catch(e:Dynamic) Std.string(value);
            case TNull      : 'null';
            case TInt       : 'int';
            case TFunction  : 'function';
            case TFloat     : 'float';
            case TEnum(e)   : '${Type.getEnumName(e)}.${Type.enumConstructor(cast value)}';
            case TClass(e)  : Type.getClassName(e);
            case TBool      : 'bool';
        }
    }

    public static function getSimpleName<T>(value : T)  : String {
        function extract(name : String) {
            var runtimeIndexName = name.indexOf('{');
            return if (runtimeIndexName >= 0) 'Unknown';
            else name.substr(name.lastIndexOf(".") + 1);
        }

        var name = getName(value);
        return switch (Type.typeof(value)) {
            case TObject: extract(name);
            case TClass(_): extract(name);
            case _: name;
        }
    }

    public static function getClass<T>(value : T) : Class<T> return Type.getClass(value);

    inline public static function isTypeOf<T>(value : T, possible : String) : Bool {
        var value = switch(Type.typeof(value)) {
            case TUnknown   : 'unknown';
            case TObject    : 'object';
            case TNull      : 'null';
            case TInt       : 'int';
            case TFunction  : 'function';
            case TFloat     : 'float';
            case TEnum(_)   : 'enum';
            case TClass(_)  : 'class';
            case TBool      : 'bool';
        }
        return value == possible;
    }

    public static function isObject<T>(value : T) : Bool return isTypeOf(value, 'object');
    public static function isNull<T>(value : T) : Bool return isTypeOf(value, 'null');
    public static function isInt<T>(value : T) : Bool return isTypeOf(value, 'int');
    public static function isFunction<T>(value : T) : Bool return isTypeOf(value, 'function');
    public static function isFloat<T>(value : T) : Bool return isTypeOf(value, 'int');
    public static function isEnum<T>(value : T) : Bool return isTypeOf(value, 'enum');
    public static function isClass<T>(value : T) : Bool return isTypeOf(value, 'class');
    public static function isBoolean<T>(value : T) : Bool return isTypeOf(value, 'bool');

    public static function isPrimitive<T>(v:T):Bool{
        return switch (Type.typeof(v)) {
            case TInt, TFloat, TBool : true;
            default                  : false;
        }
    }
    public static function asInstanceOf<T : Any, R>(value : T, possible : Class<R>) : R {
        // Runtime cast, rather than a compile type cast.
        return isInstanceOf(value, possible) ? cast value : throw 'Cannot cast $value to $possible';
    }

    public static function isInstanceOf<T : Any>(value : T, possible : Any) : Bool {
        // Performance optimisation.
        #if js
        untyped {
            if(__js__('value === null || possible === null')) return false;

            if(__js__('typeof(possible) === "function"')) {
                if(__js__("value instanceof possible")) {
                    if(possible == Array) return (value.__enum__ == null);
                    return true;
                }

                if(__interfLoop(value.__class__, possible)) return true;
            }

            switch(possible) {
                case Int        : return __js__("Math.ceil(value % 2147483648.0) === value");
                case Float      : return __js__("typeof(value)") == "number";
                case Bool       : return __js__("value === true || value === false");
                case String     : return __js__("typeof(value)") == "string";
                case Dynamic    : return true;
                default:
                    // do not use isClass/isEnum here
                    __feature__("Class.*", if(possible == Class && value.__name__ != null) return true);
                    __feature__("Enum.*", if(possible == Enum && value.__ename__ != null) return true);
                    return value.__enum__ == possible;
            }
        }
        #else
        return Std.is(value, possible);
        #end
    }

    public static function isValueOf<T : Any>(value : T, possible : Any) : Bool {
        return if (value == null || possible == null) false;
        else switch(Type.typeof(value)) {
            case TEnum(_) if(isInstanceOf(possible, Enum)): Type.getEnum(value) == possible;
            case TEnum(_) if(isEnum(possible) && Type.enumEq(value, possible)): true;
            case _: equals(value, possible);
        }
    }

    public static function toBool<T>(value : Null<T>) : Bool {
        return if(value == null) false;
        else if(isInstanceOf(value, Bool)) cast (value,Bool);
        else if(isInstanceOf(value, Float) || isInstanceOf(value, Int)) cast(value) > 0;
        else if(isInstanceOf(value, String)) Strings.isNotEmpty(cast value);
        else if(isInstanceOf(value, Option)) Options.toBool(cast value);
        else if(isInstanceOf(value, Either)) Eithers.toBool(cast value);
        else true;
    }

    public static function toString<T>(value : T, ?func : T->String) : String {
        // NOTE (Simon) : Workout if the value has a toString method
        return if(toBool(func)) func(value);
        else Std.string(value);
    }
    private static function __interfLoop(cc : Dynamic, cl : Dynamic) {
        if(cc == null) return false;
        if(cc == cl) return true;

        var intf : Dynamic = cc.__interfaces__;
        if(intf != null) {
            for(i in 0...intf.length) {
                var i : Dynamic = intf[i];
                if(i == cl || __interfLoop(i,cl)) return true;
            }
        }
        return __interfLoop(cc.__super__,cl);
    }
  /**
		Dive into an object using 'a:b:c' notation, returns an error with the unfound token in the path if the operation fails.
	**/
  static public function dive<A,B>(o:A,path:Path):Chunk<B>{
    if(o == null) return End(Error.withData(path,MatchError(path)));
    if(path == '') return cast Chunks.create(o);
    var fields            = path!= null ? path.nodes() : [];
    var next              = fields.shift();
    var path              = [];
    var val : Dynamic     = o;

    while(val != null){
      path.push(next);
      try{
        val = Reflect.field(val,next);
      }catch(e:Dynamic){
        return End(Error.withData(Std.string(e),NativeError(e)));
      }
      if(val==null){
        var end = path.last();
        var p0  = path.dropRight(1).join(':');
        return End(Error.withData('$p0[$end]',MatchError('$p0[$end]')));
      }
      next = fields.shift();
      if(next ==
       null) break;
    }
    return Chunks.create(val);
  }
  /**
		Dive into an object using 'a:b:c' notation, returns a Nil if the operation fails
	**/
  static public function diveOption<A,B>(o:A,path:Path):Chunk<B>{
    if(o == null) return Nil;
    if(path == '') return Chunks.create(cast o);
    var fields            = path.nodes();
    var next              = fields.shift();
    var path              = [];
    var val : Dynamic     = o;

    while(val != null){
      path.push(next);
      try{
        val = Reflect.field(val,next);
      }catch(e:Dynamic){
        return End(Error.withData(Std.string(e),NativeError(e)));
      }
      if(val==null){
        return Nil;
      }
      next = fields.shift();
      if(next == null) break;
    }
    return Chunks.create(val);
  }
  /**
		Returns the values in `val` specified in `keys`, producing an error with the unfound keys if the operation fails.
	**/
  static public function gather(val:Dynamic,keys:Array<String>):Upshot<Dynamic>{
    return keys.foldLeft(
      [],
      function(memo:Array<Either<String,Tuple2<String,Dynamic>>>,next:String){
        return if(Reflect.hasField(val,next)){
          memo.add(Right(val.getField(next)));
        }else{
          memo.add(Left(next));
        }
      }
    ).partition(
      Eithers.isLeft
    ).into(
      function(l:Array<Dynamic>,r:Array<Dynamic>){
        return tuple2(
          l.map(Eithers.left.then(Options.val)),
          r.map(Eithers.right.then(Options.val))
        );
      }
    ).into(
      function(l,r:Array<Tuple2<String,Dynamic>>):Upshot<Dynamic>{
        return if(l.length>0){
          Failure(Error.withData('missing ${l.join(",")}',MatchError(l)));
        }else{
          Success(stx.Objects.toObject(r));
        }
      }
    );
  }
  /**
		Set `v` in `data` at `path` using an `Path`, if `safe` is true, will not set on a previously existing value
	**/
  @:noUsing static public function set<V>(data:V,path:Path,v:Dynamic,?safe=true):V{
    var paths           = path.nodes();
    var last            = paths.pop();
    var par             = paths.foldLeft(
      data,
      function(memo,next){
        var o = Reflect.field(memo,next);
        if( o == null ){ 
          o = {};
          Reflect.setField(memo,next,o);
        }
        return cast o;
      }
    );
    if(safe){
      if(Reflect.field(par,last) == null){
        Reflect.setField(par,last,v);
      }
    }else{
       Reflect.setField(par,last,v);
    }
    return data;
  }
  /**
		Call `set` with `safe=false`.
	**/
  @:noUsing static public function replace<V>(data:V,path:Path,v:Dynamic):V{
    return set(data,path,v,false);
  }
  /**
		Delete value at `key` in `data` using an `Path`.
	**/
  static public function del<T>(data:T,key:Path):T{
    var keys  = key.nodes();
    var keys0 = keys.dropRight(1).reversed();
    var keys1 = keys.dropRight(2).reversed();


    if(keys0.length == 0){
      Reflect.deleteField(data,key);
      return data;
    }
    var r     = diveOption(data,keys1.join(':'));
    return r
      .map(
        function(parent:Dynamic){
          Reflect.deleteField(parent,keys.last());
          return parent;
        }
      ).fold(
        Compose.unit(),
        function(er) return data,
        function() return data
      );
  }
  /**
		Construct `type` filled with fields of `y` will fail if `y` contains a superset (i.e, extra fields).
	**/
  static public function constructWith<O,T>(type:Class<T>,y:O):Upshot<T>{
    return stx.Types.construct.bind(type,[]).catching()()
      .flatMap(
        function(v:T):Upshot<T>{
          var tp = Type.typeof(v);
          return switch (tp){
            default :
              Failure(Error.withData('To be honest, I have no idea how you got here.',IllegalOperationError));
            case TClass( c ) :
              var keys = Reflects.keys(y);
              switch(ArrayOrder.compare(type.locals(),keys)){
                case 1  : 
                  var not = Reflects.validate(type,keys);
                  Failure(Error.withData(not.join(', ') + ' do not belong in type "${type.name()}"',MatchError(not)));
                default : Success(v);
              }
          }
        }
      ).flatMap(
        function(x){
          return Reflects.fields(y).foldLeft(x,Reflects.setFieldPair);
        }.catching()
      );
  }
  /**
		Checks that a value at `path` exists on `o`.
	**/
  static public function has(o:Dynamic,path:Path):Bool{
    var fn    = Reflect.field;
    var paths = path.nodes();
    var path  = paths.shift();
    var val   = o;
    var oc    = true;

    while(true){
      if(!Reflect.hasField(val,path)){
        oc = false;
        break;
      }
      val  = Reflect.field(val,path);
      if(val == null){
        oc = false;
        break;
      }
      path = paths.shift();
      if(path == null){
        break;
      }
    }
    return oc;
  }
}