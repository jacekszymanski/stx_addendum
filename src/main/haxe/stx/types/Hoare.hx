package stx.types;

enum Hoare<T>{
  Enter;
  Brief(v:T);
  Leave;
}