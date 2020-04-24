import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:walletmanager/apis/httprequestsapis.dart';
import 'package:walletmanager/constants.dart';
import 'package:walletmanager/screens/Home.dart';
import 'package:walletmanager/screens/login.dart';
import 'package:walletmanager/screens/register.dart';
import 'package:walletmanager/screens/resetpassword/newpasswordReset.dart';
import 'package:walletmanager/widgets/commonwidgets.dart';



class ResetSuccess extends StatefulWidget {
  @override
  _ResetSuccessState createState() => _ResetSuccessState();
}

class _ResetSuccessState extends State<ResetSuccess> {
  
  List<double> _stops = [0.0, 0.9];
  bool _isLoading=false;

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1280, allowFontScaling: false);
    var size = ScreenUtil();
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
              stops: _stops,
            ),
          ),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(size.setWidth(90)),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: size.setHeight(60),
                      width: size.setWidth(20),
                      color: Colors.red[600],
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Wallet Manager',
                      style: TextStyle(
                          fontSize: size.setSp(45),
                          color: Colors.red[600],
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    size.setWidth(90), size.setWidth(60), size.setWidth(90), 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.done_outline,
                      size: size.setWidth(100),
                      color: Colors.red[600],
                    ),
                    SizedBox(
                      height: size.setHeight(40),
                    ),
                    Text(
                      'Password Reset Successful',
                      style: TextStyle(
                          fontSize: size.setSp(40),
                          color: Colors.black87,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: size.setHeight(20),
                    ),
                    Text(
                      'Your password was successfully reset!',
                      style: TextStyle(
                          fontSize: size.setSp(24),
                          color: Colors.black87,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: size.setHeight(30),
                    ),
                    
                    
                    SizedBox(
                      height: size.setHeight(60),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: size.setHeight(80),
                          width: size.setWidth(250),
                          child: FlatButton(
                            disabledColor: Colors.red[400],
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(size.setWidth(10)),
                              // side: BorderSide(color: Colors.red)
                            ),
                            color: red3,
                            onPressed:_isLoading? null: () async {
                              //await _passwordresetRequest();
                              Navigator.pushReplacement(context, PageTransition(
                                child:Login(),
                                type: PageTransitionType.slideInRight
                                 ));
                            },
                            child: _isLoading? spinkitwhite: Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: size.setSp(22),
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.setHeight(120),
                    ),
                    
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}