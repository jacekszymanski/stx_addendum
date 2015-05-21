package stx.ifs;

interface Model<G,P>{
  public function pop():G;
  public function put(p:P):Void;
}