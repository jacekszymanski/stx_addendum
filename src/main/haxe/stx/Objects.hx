package stx;

import tink.core.Pair;
import stx.Compare.*;

using stx.Pairs;

import haxe.ds.StringMap;
import stx.Compare;
import stx.Tuples;

using stx.Options;
using stx.Tuples;
using stx.Functions;
using stx.Compose;
using stx.Predicate;
import stx.types.*;

using stx.Arrays;
using stx.Iterables;

import Type;

typedef Object = {};

/**
	Object defined as {} is different from Dynamic in that it does not allow closures.
**/
class Objects {
  
  @:noUsing static public function unit():Object{
    return {}
  }
  @:noUsing static public function asObject(d:Dynamic):Object{
    return cast d;
  }
  static public function toObject<A>(a:Array<KV<A>>):Object{
    return a.foldLeft(
      {},
      function(init,el){
        Reflect.setField( init , el.fst(), el.snd() );
        return init;
      }
    );
  }
  static public function copy(o:Object):Object{
    var flds  = Reflects.fields(o);
    var obj   = {}
    return flds.foldLeft(obj,cast Reflects.setFieldTuple.bind(obj));
  }
  /**
		Return the fields of Object.
	**/
  static public function fields(o:Object):Iterable<Pair<String,Dynamic>>{
    return Reflects.fields(o);
  }
  
  /**
		Returns the values of the names.
	**/
  static public function select(d:Object,names:Array<String>):Array<Dynamic>{
    return Tables.select(d,names);
  }
  static public function iterator(d: Object): Iterator<String> {
    return Reflect.fields(d).iterator();
  }
  /**
		The fields exist.
	**/
  static public function included(d:Object,flds:Array<String>):Bool{
    return missing(d,flds).isEmpty();
  }
  /**
		Report fields missing.
	**/
  static public function missing(d:Object,flds:Array<String>):Option<Array<String>>{
    return Tables.missing(d,flds);
  }
  @:docs("Reports true if the object contains only the supplied fields.")
  static public function only(d:Object,flds:Array<String>):Bool{
    return Tables.only(d,flds);
  }
  /**
		The fields are non null.
	**/
  static public function defined(d:Object,flds:Array<String>):Bool{
    return fields(d).filter(
      function(x:String,y:Dynamic):Bool{
        return flds.any(eq(x));
      }.paired()
    ).all( ntnl() );
  }
  /**
		Merges the first level of object keys into a new Object, right hand override.
	**/
  static public function merge<T0: Object,T1: Object,U : Object>(o0:T0,o1:T1):U{
    return cast Tables.merge(cast o0,cast o1);
  }
  @doc("")
  static public function toMap(o:Object):StringMap<Dynamic>{
    var map = new StringMap();
    fields(o).each(map.set.paired());
    return map;
  }
  static public function setField(o:Object,k:String,v:Dynamic):Object{
    Reflect.setField(o,k,v);
    return o;
  }
  static public function putIfNotNull(o:Object,k:String,v:Dynamic):Void{
    if(v!=null){
      setField(o,k,v);
    }
  }
}