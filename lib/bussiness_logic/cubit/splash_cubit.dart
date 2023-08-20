import 'dart:async';


import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashInitial> {
  SplashCubit() : super(SplashInitial());

  timer(BuildContext context){
    Timer.periodic(Duration(seconds: 1), (timer) {
      emit(state.add());

      if(state._second==5){
        timer.cancel();
       Navigator.of(context).push(MaterialPageRoute(builder: (_)=>))
    });
  }
}
