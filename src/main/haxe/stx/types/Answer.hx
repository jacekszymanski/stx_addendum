package stx.types;

import tink.core.Error;

typedef Answer<T> = {
  @:optional public var value     : Null<T>;
  @:optional public var error     : Null<Error>;
}