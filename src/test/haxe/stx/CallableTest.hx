package stx;

class CallableTest{
  public function new(){
    
  }
  public function testCallable(){
    var a = new TestApply();
  } 
}
@:callable class TestApply implements stx.ifs.Apply<Int,Int>{
  public function new(){}
  public function apply(v:Int){
    return v;
  }
}