

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

class SingleGestureReconizer extends OneSequenceGestureRecognizer{
  bool pointerActive = false;
  ValueChanged<PointerEvent>? onStart;
  ValueChanged<PointerEvent>? onEnd;
  ValueChanged<PointerEvent>? onUpdate;


  SingleGestureReconizer({
    Object? debugOwer,
    Set<PointerDeviceKind>? kind,

}):super(debugOwner: debugOwer,supportedDevices:kind);
  @override
  // TODO: implement debugDescription
  String get debugDescription => "single_gesture_reconizer";

  @override
  void didStopTrackingLastPointer(int pointer) { }

  @override
  void handleEvent(PointerEvent event) {

 if(event is PointerMoveEvent){
   onUpdate?.call(event);
 } else if(event is PointerDownEvent){
   pointerActive = true;
   onStart?.call(event);
 }else if(event is PointerUpEvent){
   pointerActive = false;
   onEnd?.call(event);
 }else if(event is PointerCancelEvent){
   pointerActive = false;
   onEnd?.call(event);
 }
  }


  
}