package stx.test;

import stx.types.Fault;
import tink.core.Error;
import haxe.PosInfos;

import stx.Tuples;
import stx.types.*;
 
import stx.Equal;
import stx.Compare;

using stx.Compose;
using stx.Functions;
using stx.Compose;
using stx.Bools;
using stx.Anys;
using stx.Options;
using stx.Tuples;
using stx.test.Assert;

@doc("
  Use in conjunction with stx.Compare for generating arbitrary assertions.
")
class Assert{
	@:noUsing static public inline function assert<T>(?v:Null<T>,?str:String,?prd:Predicate<Dynamic>,?er:Error,?pos:PosInfos):Void{
    prd = prd == null ? Compare.ntnl()                                    : prd;
		er  = er  == null ? Error.withData('assert failed',AssertionError(str == null ? Std.string(v)   : str),pos) : er;
		if(!prd.apply(v)){
			throw(er);
		}
	}
}