part of 'splash_cubit.dart';

abstract class SplashState extends Equatable {
  const SplashState();
}

class SplashInitial extends SplashState {
  int _second = 0;

  add(){
    _second++;
  }
  @override
  List<Object> get props => [_second];
}
