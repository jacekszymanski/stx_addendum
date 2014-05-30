package stx;

import haxe.PosInfos;

class Positions {
  static public var nil : PosInfos = Positions.create(null,null,null,null);
  static public function toString(pos:PosInfos){
    if (pos == null) return '<unknown position>';
    return '|[' + pos.fileName +  ']' + pos.className + "#" + pos.methodName + ":" + pos.lineNumber + '|';
  }
  static public function here(?pos:PosInfos) {
    return pos;
  }
  @:noUsing static public function create(fileName,className,methodName,lineNumber:Null<Int>):PosInfos{
    return {
      fileName   : fileName,
      className  : className,
      methodName : methodName,
      lineNumber : lineNumber
    };
  }
  @noUsing static public function withFragmentName(pos:PosInfos):String{
    return '${pos.className}#${pos.methodName}';
  }
} 