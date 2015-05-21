package stx.ifs;

interface Link<S,T>{
  public var source(default,null) : S;
  public var target(default,null) : T;
}