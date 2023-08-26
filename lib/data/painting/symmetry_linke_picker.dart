import 'package:flutter/cupertino.dart';

class SymmetyLinkPicker  extends CustomPaint{
  final double symmertyLine;
  SymmetyLinkPicker({
  required  this.symmertyLine
});
  @override
  void paint(Canvas canvas,Size size){
    for(int i=0 ; i<symmertyLine ;i ++){
       canvas.drawLine(Offset.zero, Offset(100, 100), Paint());
    }
    canvas.rotate(symmertyLine/360);
  }

  @override
  bool shouldRePaint(SymmetyLinkPicker oldDelegate){
    return true;
  }

}