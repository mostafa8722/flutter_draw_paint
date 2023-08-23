part of 'recorder_bloc.dart';

@immutable
abstract class RecorderState {}

class RecorderInitial extends RecorderState {}
class RecordState extends RecorderState {
  RecordStatus record;
  Object? obj;
  RecordState(this.record,{this.obj});
}
class MessageState extends RecorderState {
  String? message;

  MessageState({this.message});
}
class ShowGifState extends RecorderState {
  final gif;

  ShowGifState({this.gif});
}
