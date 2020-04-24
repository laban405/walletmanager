import 'package:flutter/material.dart';

Color monthcolor1 = Colors.white;
Color monthcolor2 = Colors.red[600];
String selectedincomeid;
String accName;



class MESSAGES {
  static const String INTERNET_ERROR = "No Internet Connection";
  static const String INTERNET_ERROR_RETRY =
      "No Internet Connection.\nPlease Retry";
}

class COLORS {
  // App Colors //
  static const Color DRAWER_BG_COLOR = Colors.lightGreen;
  static const Color APP_THEME_COLOR = Colors.green;
}

Future<List> accountmonths() async {
  List listmonths = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  
  //print('months list  $listmonths');
  return listmonths;
}
