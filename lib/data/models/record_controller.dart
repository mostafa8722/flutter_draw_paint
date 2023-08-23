import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doddle/data/models/frame.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as image;
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

  Future<List<int>?> export() async{
    List<RawFrame> bytes = [];

    for( final frame in frames!){
      final i = await frame.frame!.toByteData(format: ui.ImageByteFormat.png);
      if(i!=null){
        bytes.add(RawFrame(23, i));
      }else{
        print("skipped frame while encoding");
      }
    }
    final result = compute((message) => null, bytes);
    frames!.clear();
    return result;
    
  }

  static Future<List<int>?> _export(List<RawFrame> frames)async{
    final animation = image.Animation();
    animation.backgroundColor = Colors.transparent.value;
    for(final frame in frames){
      final iAsBytes = frame.data.buffer.asUint8List();
      final decodedImage = image.decodePng(iAsBytes);

      if(decodedImage==null){
        print("skipped frame while encoding");
        continue;
      }
      decodedImage.duration =  frame.durationMillisecond;
      animation.addFrame(decodedImage);
    }
    return image.encodeGifAnimation(animation);
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