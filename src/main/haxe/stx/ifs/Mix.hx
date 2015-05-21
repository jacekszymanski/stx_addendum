package stx.ifs;

interface Mix<T> extends Immix<T,Dynamic>{
  
}
  
interface Mix2<K,V> extends Mix<K>{
  public function immix(i:K,s:V):Void;
}