package stx;

using stx.Arrays;
using stx.Tuples;
import stx.types.Tuple2;

class Maps{
  static public function putIfNotNull<K,V>(map:Map<K,V>,tp:Tuple2<K,V>):Void{
    if(tp.fst() == null || tp.snd() == null){
      return;
    }else{
      put(map,tp);
    }
  }
  static public function put<K,V>(map:Map<K,V>,tp:Tuple2<K,V>){
    map.set(tp.fst(),tp.snd());
  }
  static public function patch<K,V>(map:Map<K,V>,arr:Array<Tuple2<K,V>>,?keepNull:Bool = true){
    if(keepNull){
      arr.each(put.bind(map));
    }else{
      arr.each(putIfNotNull.bind(map));
    }
  }
}