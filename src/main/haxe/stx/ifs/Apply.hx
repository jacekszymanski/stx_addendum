package stx.ifs;

import tink.core.Error;
import stx.types.Fault;

import stx.types.*;

using stx.Options;
using stx.Functions;
using stx.Compose;

typedef ApplyType<I,O> = {
	function apply(v:I):O;
}
interface Apply<I,O>{
	public function apply(v:I):O;
}
/*interface Apply2<A,B,O>{
  public function apply2(a:A,b:B):O;
}
interface Apply3<A,B,C,O>{
  public function apply3(a:A,b:B,c:C):O;
}*/
class DefaultApply<E,A> implements Apply<E,A>{
	public function new( ){

	}
	public function apply(v:E):A{
		return throw Error.withData('Error null',ArgumentError('apply',NullError));
	}
}
class AnonymousApply<E,A> implements Apply<E,A>{
  private var __apply__ : E -> A;
  public function new(__apply__){
    this.__apply__ = __apply__;
  }
  public function apply(e:E):A{
    return __apply__(e);
  }
}