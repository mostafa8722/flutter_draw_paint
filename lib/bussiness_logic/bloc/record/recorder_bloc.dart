import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:doddle/data/enums/record_status.dart';
import 'package:doddle/data/models/record_controller.dart';
import 'package:meta/meta.dart';
import 'package:screen_recorder/screen_recorder.dart';

part 'recorder_event.dart';
part 'recorder_state.dart';

class RecorderBloc extends Bloc<RecorderEvent, RecorderState> {
  ScreenRecorderController? controller;
  RecordController? recordController;
  List<int>? old_gif = [];
  RecorderBloc({this.controller}) : super(RecorderInitial()) {
    on<StartRecordingEvent>(handleStartRecordingEvent);
   on<PrepareVideoPageEvent>(handlePrepareVideoPageEvent);
  }

   handleStartRecordingEvent(StartRecordingEvent event,Emitter<RecorderState> emit)async*{
   controller!.start();
    yield RecordState(RecordStatus.startRecording);
  }
  handlePrepareVideoPageEvent(PrepareVideoPageEvent event,Emitter<RecorderState> emit)async*{
    print("old_gif:\n$old_gif");
    controller!.stop();
    yield RecordState(RecordStatus.prepareVideo);

    List<int>? gif = await  recordController!.export();
    yield RecordState(RecordStatus.donePreparingVideo,
    obj: gif!.followedBy(old_gif??[]).toList(), );
    old_gif = gif.followedBy(old_gif??[]).toList();
  }
}
