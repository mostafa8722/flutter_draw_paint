import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:doddle/data/enums/pen_tool.dart';
import 'package:doddle/data/models/draw_controller.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  DrawController? drawController;
  var index =0 ;
  HomeBloc({this.drawController}) : super(UpdateCanvasState()) {
    on<ClearPointEvent>(handleClearPointEvent);
    on<AddSceneEvent>(handleAddSceneEvent);
    on<ClearStampsEvent>(handleClearStampsEvent);
    on<ShareImageEvent>(handleShareImageEvent);
    on<AddPointEvent>(handleAddPointEvent);
    on<UndoStampEvent>(handleUndoStampEvent);
    on<RedoStampEvent>(handleRedoStampEvent);
    on<ChangePenToolEvent>(handleChangePenToolEvent);
    on<ChangePenSizeEvent>(handleChangePenSizeEvent);
    on<InitGlobalKeyEvent>(handleInitGlobalKeyEvent);
    on<TakePageStampEvent>(handleTakePageStampEvent);
    on<ChangeCurrentColorEvent>(handleChangeCurrentColorEvent);
    on<SavePageToGalleryEvent>(handleSavePageToGalleryEvent);
    on<UpdateSymmetryLinesEvent>(handleUpdateSymmetryLinesEvent);
    on<CallNextFrameEvent>(handleCallNextFrameEvent);
    on<ShowVideoEvent>(handleShowVideoEvent);
    on<MessageEvent>(handleMessageEvent);
  }

  handleClearPointEvent(ClearPointEvent event,Emitter<HomeState> emit) async*{
    drawController!.points!.clear();
    yield UpdateCanvasState(drawController: drawController);
  }
  handleAddSceneEvent(AddSceneEvent event,Emitter<HomeState> emit){}
  handleClearStampsEvent(ClearStampsEvent event,Emitter<HomeState> emit)async*{
    if(event.ok){
      if(drawController!.stamp!.isEmpty) return ;
      drawController!.stamp!.clear();
      yield UpdateCanvasState(drawController: drawController);
    }
  }
  handleShareImageEvent(ShareImageEvent event,Emitter<HomeState> emit)async*{
    try{
      screenShotAndShare(
        event.globalKey ??drawController!.globalKey,event.context!
      );
    }catch(e){
     yield MessageState(e.toString());
    }
  }
  handleAddPointEvent(AddPointEvent event,Emitter<HomeState> emit)async*{
    if(drawController!.isPenActive){
      drawController!.points.add(event.point);
      if(event.end!){
        add(TakePageStampEvent(drawController!.globalKey!));
      }
    }
    yield UpdateCanvasState(drawController: drawController);
  }
  handleUndoStampEvent(UndoStampEvent event,Emitter<HomeState> emit)async*{
    if(drawController!.stamp!.isNotEmpty){
      List<Stamp> stamps = List.from(drawController!.stamp!);
      final undos= stamps.removeLast();

      List<Stamp> undostamps = List.from(drawController!.stampUndo!);
      undostamps.add(undos);
      drawController = drawController!.copyWith(stamp:stamps ,stampUndo: undostamps);
      yield UpdateCanvasState(drawController: drawController);

    }
  }
  handleRedoStampEvent(RedoStampEvent event,Emitter<HomeState> emit)async*{
    if(drawController!.stampUndo!.isNotEmpty){
      List<Stamp> undostamps = List.from(drawController!.stampUndo!);
      final redo= undostamps.removeLast();

      List<Stamp> stamps = List.from(drawController!.stamp!);
      stamps.add(redo);
      drawController = drawController!.copyWith(stamp:stamps ,stampUndo: undostamps);
      yield UpdateCanvasState(drawController: drawController);

    }
  }
  handleChangePenToolEvent(ChangePenToolEvent event,Emitter<HomeState> emit)async*{
    drawController = drawController?.copyWith(penTool: event.penTool);
    yield UpdateCanvasState(drawController: drawController);
  }
  handleChangePenSizeEvent(ChangePenSizeEvent event,Emitter<HomeState> emit)async*{
    drawController = drawController?.copyWith(penSize: event.penSize);
    yield UpdateCanvasState(drawController: drawController);
  }
  handleInitGlobalKeyEvent(InitGlobalKeyEvent event,Emitter<HomeState> emit)async*{
    drawController = drawController?.copyWith(globalKey: event.globalKey);
    yield UpdateCanvasState(drawController: drawController);
  }
  handleTakePageStampEvent(TakePageStampEvent event,Emitter<HomeState> emit)async*{

    try{
      ui.Image image = await convastToImage(event.globalKey);
      List<Stamp>? stamps =List.from(drawController!.stamp!);
      stamps.add(Stamp(image: image));
      drawController = drawController?.copyWith(stamp: stamps);
      add(ClearPointEvent());
    }catch(e){
     yield MessageState(e.toString());
    }
    yield UpdateCanvasState(drawController: drawController);

  }
  handleChangeCurrentColorEvent(ChangeCurrentColorEvent event,Emitter<HomeState> emit)async*{
    drawController = drawController?.copyWith(currentColor: event.color,isRandomColor: event.isRandomColor);
    yield UpdateCanvasState(drawController: drawController);
  }
  handleSavePageToGalleryEvent(SavePageToGalleryEvent event,Emitter<HomeState> emit)async*{
    save(event!.globalKey??drawController!.globalKey!);
  }
  handleUpdateSymmetryLinesEvent(UpdateSymmetryLinesEvent event,Emitter<HomeState> emit) async*{
    drawController = drawController?.copyWith(symetryLines: event.symmetryLines);
    yield UpdateCanvasState(drawController: drawController);
  }
  handleCallNextFrameEvent(CallNextFrameEvent event,Emitter<HomeState> emit){}
  handleShowVideoEvent(ShowVideoEvent event,Emitter<HomeState> emit)async*{
    yield ShowRecordState();
  }
  handleMessageEvent(MessageEvent event,Emitter<HomeState> emit)async*{
    yield MessageState(event.message,isClear: event.isClear);
    yield UpdateCanvasState(drawController: drawController);
  }
  Future<Null> screenShotAndShare(GlobalKey? globalKey,BuildContext context) async{

    try{
      print("Phase 1"*200);
      RenderRepaintBoundary boundary = globalKey!.currentContext!.findRenderObject() as RenderRepaintBoundary;
     ui.Image image = await boundary.toImage();
     final directory = (await getExternalStorageDirectory())?.path;
     ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
     Uint8List pngByts =byteData!.buffer.asUint8List();
     print("Phase 2"*200);

     File file = File("$directory/screenshot.png");
     file.writeAsBytes(pngByts);
     print("Screenshot path : "+file.path);
     print("Phase 3"*200);
     final RenderBox renderBox = context.findRenderObject() as RenderBox;
     Share.shareFiles(['$directory/screenshot.png'],
     subject: "app painting",
       text: "Hey check out my amazing app",
       sharePositionOrigin: renderBox.localToGlobal(Offset.zero) & renderBox.size
     );
      print("Phase 4"*200);
    }catch(e){
      add(MessageEvent(e.toString()));
    }
  }
   Future<ui.Image> convastToImage(GlobalKey globalKey) async{
    final boundry = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundry.toImage();
    return image;
   }

   Future<void> save(GlobalKey globalKey)  async{
   try{

     final boundry = globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
     final image = await boundry.toImage();
     final bytData = await image.toByteData(format: ui.ImageByteFormat.png);
     final pngByt = bytData!.buffer.asUint8List();
     final save  = ImageGallerySaver.saveImage(
       pngByt,quality: 100,
       name: DateTime.now().toIso8601String()+".jpeg",
       isReturnImagePathOfIOS:true,
     );
     add(MessageEvent("saved  to gallery!"));
   }catch(e){
     add(MessageEvent(e.toString()));
   }
   }


}

