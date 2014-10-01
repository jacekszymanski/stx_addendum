package stx;

using stx.Tuples;
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
    var fn = keepNull ? function(x){return true;} : function(x:Field<V>) {return x.snd() != null;}
    obj.fields().filter(fn).each(put.bind(map));
  }
}