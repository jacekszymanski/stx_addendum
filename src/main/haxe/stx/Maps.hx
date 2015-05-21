package stx;

import Map;
using stx.Reflects;
import stx.Tuples.*;

using stx.Tuples;
import stx.types.Table;
import stx.types.Tuple2;
using stx.Tuples;
using stx.Iterators;
import haxe.ds.StringMap;
import tink.core.Pair;
using stx.Iterables;
import stx.types.Field;
using stx.Tables;
using stx.Arrays;


class Maps{
  static public function putIfNotNull<K,V>(map:Map<K,V>,tp:Pair<K,V>):Void{
    if(tp.b == null){
      return;
    }else{
      put(map,tp);
    }
  }
  static public function put<K,V>(map:Map<K,V>,tp:Pair<K,V>){
    map.set(tp.a,tp.b);
  }
  static public function replace<K,V>(map:Map<K,V>,arr:Array<Pair<K,V>>,?keepNull:Bool = true){
    if(keepNull){
      arr.each(put.bind(map));
    }else{
      arr.each(putIfNotNull.bind(map));
    }
  }
  static public function patch<V>(map:Map<String,V>,obj:Table<V>,?keepNull:Bool = true){
    var fn = keepNull ? function(x){return true;} : function(x:Field<V>) {return x.b != null;}
    obj.fields().filter(fn).each(put.bind(map));
  }
  static public function each<K,V>(map:Map<K,V>,fn:K->V->Void):Map<K,V>{
    for (k in map.keys()){
      var val = map.get(k);
      fn(k,val);
    }
    return map;
  }
  static public inline function kvs<K,V>(map:IMap<K,V>):Iterator<Tuple2<K,V>>{
    return map.keys().zip(map.iterator());
  }
  static public inline function size<K,V>(map:Map<K,V>):Int{
    return map.keys().size();
  }
}
class StringMaps{
  @:noUsing static public function unit<T>():StringMap<T>{
    return new StringMap();
  }
  static public inline function kvs<V>(map:StringMap<V>):Iterator<Tuple2<String,V>>{
    return map.keys().zip(map.iterator());
  }
  static public function copy<V>(map:StringMap<V>):StringMap<V>{
    var map1 = new StringMap();
    kvs(map).each(
      function(l,r){
        map1.set(l,r);
      }.tupled()
    );
    return map1;
  }
  static public function lay<V>(map:StringMap<V>,vl:Tuple2<String,V>):StringMap<V>{
    var o = copy(map);
        o.set(vl.fst(),vl.snd());
    return o;
  }
  static public function add<V>(map:StringMap<V>,k:String,v:V):StringMap<V>{
    var o = copy(map);
        o.set(k,v);
    return o;
  }
  static public function append<V>(map0:StringMap<V>,map1:StringMap<V>):StringMap<V>{
    var o = new StringMap();
    kvs(map0).each(lay.bind(o));
    kvs(map1).each(lay.bind(o));
     return o;
  }
  static public function toDynamic<V>(map:StringMap<V>):Dynamic{
    var o : Dynamic = {};
    kvs(map).each(
      o.setFieldTuple.bind(o)
    );
    return o;
  }
  static public function toArray<T>(map:StringMap<T>):Array<Tuple2<String,T>>{
    return kvs(map).toArray();
  }
  static public function stripNullValues<T>(map:StringMap<T>):StringMap<T>{
    var nxt = new StringMap();
    kvs(map).each(
      function(k,v){
        if(v!=null){
          nxt.set(k,v);
        }
      }.tupled()
    );
    return nxt;
  }
  static public function toObject(map:StringMap<Dynamic>):Dynamic{
    var obj : Dynamic = {};
    kvs(map).each(
      function(l,r){
        Reflect.setField(obj,l,r);
      }.tupled()
    );
    return obj;
  }
  public static inline function has(h:StringMap<String>, entries:Array<String>):Bool {
    var ok = true;
    
    for (val in entries) {
      if ( !h.exists(val) ) {
        ok = false;
        break;
      }
    }
    return ok;
  }
}