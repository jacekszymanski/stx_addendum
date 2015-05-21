package stx.ds;

import haxe.ds.IntMap;
import stx.Hasher;

abstract Set<T>(IntMap<T>) from IntMap<T>{
  public function new(?v){
    v = v == null ? new IntMap() : v;
    this = v;
  }
  private function copyMap(){
    var n = new IntMap();
    for(key in this.keys()){
      n.set(key,this.get(key));
    }
    return n;
  }
  public function add(v:T){
    var hash = Hasher.getHashFor(v)(v);
    var next = copyMap();
    if(!this.exists(hash)){
      next.set(hash,v);
    }
    return new Set(next);
  }
  public function rem(v:T){
    var hash = Hasher.getHashFor(v)(v);
    var next = copyMap();
        next.remove(hash);
    return new Set(next);
  }
  public function append(set:Set<T>){
    var next : Set<T> = this;
    for(el in set){
      next = next.add(el);
    }
    return next;
  }
  public function exists(v:T){
    var hash = Hasher.getHashFor(v)(v);
    return this.exists(hash);
  }
  public function iterator(){
    return this.iterator();
  }
}