import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
void ToastMsg(String text){
        Fluttertoast.showToast(
        msg: text,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.blueGrey,
        fontSize: 12.0);
  }
