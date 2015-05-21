package stx.types;


import tink.core.Error;

enum Chunk<V>{
  Val(v:V);
  Nil;
  End(?err:Error);
}