import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doddle/data/models/frame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui' as ui;

class RecordController {

  final GlobalKey? globalKey;
  final List<Frame>? frames;

  RecordController({this.globalKey,this.frames});
  RecordController copyWith({
    GlobalKey? globalKey,
    List<Frame>? frames
}){
    return RecordController(
      globalKey: globalKey??this.globalKey,
      frames: frames??this.frames
    );
  }

  Future<Uint8List> converImageToUint8List(ui.Image image) async{
     ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
     Uint8List pngByte = byteData!.buffer!.asUint8List();

    return pngByte;
  }

  @override
  String toString()=>"RecordController(globalKey:$globalKey,frames:$frames)";
  @override
  bool operator ==(Object other){
    if(identical(this, other)) return true;

    return other is RecordController && other.globalKey == globalKey && listEquals(other.frames,frames) ;
  }

  @override
  int get hasCode =>globalKey.hashCode ^ frames.hashCode;
}
class RawFrame {
  int durationMillisecond;
  ByteData data;
  RawFrame(this.durationMillisecond,this.data);
}