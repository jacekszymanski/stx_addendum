package stx;


import tink.core.Error;

class Enums {
	/**
		Creates an Enum.
	**/
	@:noUsing static public inline function create<T>(e : Enum<T>, constr : String, ?params : Array<Dynamic>):T {
		return Type.createEnum(e, constr, params);
	}
	/**
		Produces the name of the Enum constructor at `index`.
	**/
	static public inline function byIndex( e : Enum<Dynamic>, index : Int):String {
		return constructors(e)[index];
	}
	/**
		Produces the index of the EnumValue.
	**/
	static public function toIndex( e : EnumValue ):Int {
		return Type.enumIndex(e);
	}
	/**
		Produces the name of the constructor of `value`.
	**/
	static public function constructor(value:EnumValue) : String {
		return Type.enumConstructor(value);
	}
	/**
		Produces the full equality of two Enums.
	**/
	static public inline function equals<T>( a : EnumValue, b : EnumValue ):Bool {
		return Type.enumEq(a, b);
	}
	/**
		Produces the parameters for the given `value`.
	**/
	static public function params( value : EnumValue ) : Array<Dynamic> {
		return try{
		 	Type.enumParameters(value); 
		}catch(e:Dynamic){
			[];
		}
	}
	/**
		Produces the Enum of the given `value`.
	**/
	static public function toEnum( value : EnumValue ) : Enum<Dynamic> {
		return Type.getEnum(value);
	}
	/**
		Produces the names of the given Enum.
	**/
	static public function constructors( e : Enum<Dynamic> ) : Array<String> {
		return Type.getEnumConstructs(e);
	}
	/**
		Produces the name of the given Enum.
	**/
	static public function name( e : Enum<Dynamic> ) : String {
		return Type.getEnumName(e);
	}
	/**
		Produces an Enum from the given `name`.
	**/
	static public function enumerify(name : String) : Enum<Dynamic> {
		return Type.resolveEnum(name);
	}
	/**
		Top level enum comparison, doesn't compare contents.
	**/
	static public function alike<T:EnumValue>(e1:T,e2:T):Bool{
		return Enums.toIndex(e1) == Enums.toIndex(e2);
	}
	/**
		Produces parameter at index `i`.
	**/
	static public function param(e:EnumValue,i:Int):Dynamic{
		return params(e)[i];
	}
}