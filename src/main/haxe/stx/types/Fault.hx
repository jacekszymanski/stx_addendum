package stx.types;

import haxe.PosInfos;
import tink.core.Error;

@doc("Extensible through the use of `FrameworkError`.")
enum Fault{
  ErrorStack(arr:Array<Error>);
  NativeError(err:Dynamic);
  FrameworkError(flag:EnumValue);
  MatchError<S,T>(is:S,?should:T);

  AssertionError<T>(is:T,?should:T);
  ArgumentError(field:String,e:Fault);

  IllegalOperationError;
  NullError();
}