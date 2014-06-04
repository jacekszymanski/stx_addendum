package stx;

using stx.Strings;
using stx.Arrays;

abstract Path(String) from String to String{
  public function new(v:String){
    this = v.split('/').join('/');
  }
  public function parent():Path{
    return this.split('/').dropRight(1).join('/');
  }
  public function child(str:String):Path{
    return this.append('/$str');
  }
  public function leaf():Path{
    return this.split('/').last();
  }
  public function nodes():Array<String>{
    return this.split('/');
  }
  @:from static public function fromArray(arr:Array<String>):Path{
    return arr.join('/');
  }
  @:to public function toArray():Array<String>{
    return this.split('/');
  }
  public function iterator():Array<String>{
    return this.split('/');
  }
  public function equals(p:Path){
    return Strings.equals(this,p);
  }
}