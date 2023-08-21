part of 'home_bloc.dart';

abstract class HomeEvent  {
  const HomeEvent();
}

class ClearPointEvent extends HomeEvent {

  ClearPointEvent();
}

class AddSceneEvent extends HomeEvent {

  AddSceneEvent();
}

class ClearStampsEvent extends HomeEvent {
 final bool ok;
 ClearStampsEvent({this.ok= false});
}

class ShareImageEvent extends HomeEvent {
  final BuildContext? context;
  final GlobalKey? globalKey;
  ShareImageEvent(this.context,this.globalKey);
}

class AddPointEvent extends HomeEvent {
  final Point? point;
  final bool? end;
  AddPointEvent({this.point=null,this.end=false});
}

class UndoStampEvent extends HomeEvent {
  UndoStampEvent();
}
class RedoStampEvent extends HomeEvent {
  RedoStampEvent();
}
class ChangePenToolEvent extends HomeEvent {
  final PenTool? penTool;
  ChangePenToolEvent({
    this.penTool = PenTool.glowPen
});
}
class ChangePenSizeEvent extends HomeEvent {
  final double penSize;
  ChangePenSizeEvent({
    this.penSize = 2
  });
}

class InitGlobalKeyEvent extends HomeEvent {
   GlobalKey globalKey;
  InitGlobalKeyEvent(
    this.globalKey
  );
}

class TakePageStampEvent extends HomeEvent {
  GlobalKey globalKey;
  TakePageStampEvent(
      this.globalKey
      );
}
class ChangeCurrentColorEvent extends HomeEvent {
  Color? color;
  final bool isRandomColor;
  ChangeCurrentColorEvent(
      this.color,this.isRandomColor
      );
}
class SavePageToGalleryEvent extends HomeEvent {
  GlobalKey? globalKey;
  SavePageToGalleryEvent({this.globalKey}
      );
}

class UpdateSymmetryLinesEvent extends HomeEvent {
  double? symmetryLines;
  UpdateSymmetryLinesEvent({this.symmetryLines}
      );
}

class CallNextFrameEvent extends HomeEvent {
  CallNextFrameEvent();
}

class ShowVideoEvent extends HomeEvent {
  ShowVideoEvent();
}
class MessageEvent extends HomeEvent {
  String message;
  bool isClear;
  MessageEvent(this.message,{this.isClear=false});
}




