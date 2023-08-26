

part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class ShowRecordState extends HomeState{


  @override
  List<Object> get props => [];
}
class UpdateConvasState  extends HomeState{
  @override
  List<Object> get props => [];
}

class UpdateCanvasState extends HomeState {
  DrawController? drawController;
  UpdateCanvasState({ this.drawController});

  @override
  List<Object> get props => [];
}

class MessageState extends HomeState {
  String message;
  bool isClear;
  MessageState(this.message,{ this.isClear= false});

  @override
  List<Object> get props => [];
}
class ChangeSliderValueState extends HomeState {

  double  penSize;
  ChangeSliderValueState({ this.penSize= 1});

  @override
  List<Object> get props => [];
}