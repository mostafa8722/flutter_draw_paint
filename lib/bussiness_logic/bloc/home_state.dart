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