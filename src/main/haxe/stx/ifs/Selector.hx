package stx.ifs;

interface Selector<T> implements Predicate<T>{
  public var data : T;
}