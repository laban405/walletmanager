
import 'package:flutter/material.dart';
import 'package:walletmanager/screens/Home.dart';
import 'package:walletmanager/screens/login.dart';

import 'screens/register.dart';
void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
title: 'M-Rescue App',
// Set OpenSans as the default app font<<With LV>>.
theme: ThemeData(    

 primaryColor: Colors.red[600],
  fontFamily: 'OpenSans'
  ),
  initialRoute: '/login',
  routes: {
    '/home': (context) => Home(),
    '/login': (contect)=>Login(),
    '/register':(context)=>Register(),
    
  }
)
);