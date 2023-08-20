


import 'dart:math';
import 'dart:ui' as ui;

import 'package:doddle/data/enums/pen_tool.dart';
import 'package:flutter/cupertino.dart';
class DrawController {
  final bool isPenActive;
  final List<Point?> points;
  final List<Stamp?> stamp;
  final List<Stamp?> stampUndo;
  final Color currentColor;
  final bool isRandomColor;
  final GlobalKey? globalKey;
  final double? symetryLines;
   final PenTool penTool;
   final double? penSize;

   DrawController({
    this.isPenActive = true,
     this.points = const [],
     this.stamp = const [],
     this.stampUndo = const [],
     this.currentColor = const Color(0x12457895),
     this.isRandomColor =false,
     this.globalKey,
     this.symetryLines = 20,
     this.penTool = PenTool.glowPen,
     this.penSize = 2

});

   DrawController copyWith({
      bool? isPenActive,
      List<Point?>? points,
      List<Stamp?>? stamp,
      List<Stamp?>? stampUndo,
      Color? currentColor,
      bool? isRandomColor,
      GlobalKey? globalKey,
      double? symetryLines,
      PenTool? penTool,
      double? penSize,
}){

     return DrawController(
        isPenActive : isPenActive??this.isPenActive,
        points : points??this.points,
        stamp:stamp??this.stamp,
        stampUndo:stampUndo??this.stampUndo,
       currentColor:currentColor??this.currentColor,
       isRandomColor:isRandomColor??this.isRandomColor,
        globalKey:globalKey??this.globalKey,
        symetryLines:symetryLines??this.symetryLines,
       penTool:penTool??this.penTool,
        penSize:penSize??this.penSize,
     );
   }

}

class Stamp{
 ui.Image image;
 Stamp({required this.image});

 Stamp copyWith({
   ui.Image? image
}){
   return Stamp(image: image?? this.image);
 }
 @override
  String toString()=>"Stamp(image:$image)";

 @override
  bool operator ==(Object other){
   if(identical(this, other)) return true;

   return other is Stamp && other.image == image;
 }

  @override
  int get hasCode =>image.hashCode;
}