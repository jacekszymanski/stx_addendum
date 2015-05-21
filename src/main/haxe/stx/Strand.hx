package stx;

/**
  What to do with strings of length > 1 when inserting?
**/
abstract Strand(String) from String to String{
  public function new(str){
    this = str;
  }
  @:arrayAccess public inline function get(i:Int) {
    return this.charAt(i);
  }
  @:arrayAccess public inline function arrayWrite(k:Int, v:String):V {
  
    return v;
  }
}