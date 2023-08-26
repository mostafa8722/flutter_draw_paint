import 'dart:async';


import 'package:bloc/bloc.dart';
import 'package:doddle/bussiness_logic/bloc/home/home_bloc.dart';

import 'package:doddle/views/home/home_screen.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashInitial> {
  SplashCubit() : super(SplashInitial());

  timer(BuildContext context){
    Timer.periodic(Duration(seconds: 1), (timer) {
      emit(state.add());

      if(state._second==5){
        timer.cancel();
       Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BlocProvider<HomeBloc>(
           child: HomeScreen(),
           create: (_)=>HomeBloc())));
    }
  });
}
}
