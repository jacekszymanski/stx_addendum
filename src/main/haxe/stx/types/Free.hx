package stx.types;

enum Free<T,U>{
  Cont(v:T);
  Done(v:U);
}