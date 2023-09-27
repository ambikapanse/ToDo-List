import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do/Auth/login.dart';
import 'package:to_do/homescrn.dart';
class SplashServices{
  void isLogin(BuildContext context){

    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if(user!=null){
      Timer(const Duration(seconds: 3), () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const Homepage()));
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      });
    }
  }
}