
import 'package:doddle/bussiness_logic/cubit/splash_cubit.dart';
import 'package:doddle/views/splash/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider<SplashCubit>(
        create: (_)=>SplashCubit(),
        child: SplashScreen(),
      ),
    );
  }
}