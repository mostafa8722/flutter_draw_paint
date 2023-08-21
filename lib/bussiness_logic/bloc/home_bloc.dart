import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:doddle/data/enums/pen_tool.dart';
import 'package:doddle/data/models/draw_controller.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;

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
    save(event.globalKey??drawController!.globalKey);
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
}
