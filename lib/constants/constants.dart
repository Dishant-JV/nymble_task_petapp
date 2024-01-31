import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Constants{
  static String homePage1="Find your favourite";
  static String homePage2="pet to adopt!";
  static String adoptMe="Adopt Me";
  static String alreadyAdopted="Already Adopted";
  static String adoptionSuccessText = "You've now adopted";


  //color
  static Color appTextColor=const Color(0xFF3F403B);

  static double getStatusBarHeight(BuildContext context){
    return  MediaQuery.of(context).padding.top;
  }

  static void setStatusBarColor(bool isDark){
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
        isDark ? Brightness.light : Brightness.dark));
  }
}