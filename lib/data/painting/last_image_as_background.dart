

import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;

class LastImgaeAsBackground extends CustomPaint{
  ui.Image? image;
  LastImgaeAsBackground({
    required this.image
});
  @override
  void paint(Canvas canvas,Size size){
    if(image!=null){
      canvas.drawImage(image!, Offset.zero, ui.Paint());
    }
  }

  @override
  bool shouldRePaint(LastImgaeAsBackground oldDelegate){
    return oldDelegate.image != image;
  }

}