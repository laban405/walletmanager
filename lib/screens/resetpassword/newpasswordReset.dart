import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:walletmanager/apis/httprequestsapis.dart';
import 'package:walletmanager/constants.dart';
import 'package:walletmanager/screens/Home.dart';
import 'package:walletmanager/screens/register.dart';
import 'package:walletmanager/screens/resetpassword/emailreset.dart';
import 'package:walletmanager/screens/resetpassword/resetsuccess.dart';
import 'package:walletmanager/widgets/commonwidgets.dart';

class NewPasswordReset extends StatefulWidget {
  @override
  _NewPasswordResetState createState() => _NewPasswordResetState();
}

class _NewPasswordResetState extends State<NewPasswordReset> {
  String _code;
  String _newpassword;
  String _confirmnewpassword;
  //String _password;
  List<double> _stops = [0.0, 0.9];
  bool _isLoading = false;

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
                    size.setWidth(90), size.setWidth(20), size.setWidth(90), 0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'New Password',
                        style: TextStyle(
                            fontSize: size.setSp(40),
                            color: Colors.black87,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: size.setHeight(40),
                      ),
                      Text(
                        'Enter the code that was sent to $resetemail',
                        style: TextStyle(
                            fontSize: size.setSp(24),
                            color: Colors.black87,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: size.setHeight(30),
                      ),
                      SizedBox(
                        height: size.setHeight(120),
                        width: size.setWidth(550),
                        child: TextFormField(
                          onSaved: (value) {
                            _code = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Code cannot be null';
                            }
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.grey[50],
                            filled: true,
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              // borderRadius:
                              //     BorderRadius.circular(size.setWidth(50)),
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            labelText: 'Reset code',
                            labelStyle: TextStyle(
                                fontSize: size.setSp(24),
                                color: Colors.grey[700]),
                            errorStyle: TextStyle(
                              fontSize: size.setSp(18),
                              color: Colors.red[600],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.setHeight(40),
                      ),
                      SizedBox(
                        height: size.setHeight(120),
                        width: size.setWidth(550),
                        child: TextFormField(
                          onSaved: (value) {
                            _newpassword = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Password cannot be empty';
                            }
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.grey[50],
                            filled: true,
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              // borderRadius:
                              //     BorderRadius.circular(size.setWidth(50)),
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            labelText: 'New password',
                            labelStyle: TextStyle(
                                fontSize: size.setSp(24),
                                color: Colors.grey[700]),
                            errorStyle: TextStyle(
                              fontSize: size.setSp(18),
                              color: Colors.red[600],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.setHeight(40),
                      ),
                      SizedBox(
                        height: size.setHeight(120),
                        width: size.setWidth(550),
                        child: TextFormField(
                          onSaved: (value) {
                            _confirmnewpassword = value;
                          },
                          validator: (String value) {
                            if (_newpassword != _confirmnewpassword) {
                              return 'Passwords do not match';
                            }
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.grey[50],
                            filled: true,
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              // borderRadius:
                              //     BorderRadius.circular(size.setWidth(50)),
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            labelText: 'Confirm new password',
                            labelStyle: TextStyle(
                                fontSize: size.setSp(24),
                                color: Colors.grey[700]),
                            errorStyle: TextStyle(
                              fontSize: size.setSp(18),
                              color: Colors.red[600],
                            ),
                          ),
                        ),
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
                              onPressed: _isLoading
                                  ? null
                                  : () async {
                                      await _passwordresetRequest();
                                      
                                    },
                              child: _isLoading
                                  ? spinkitwhite
                                  : Text(
                                      'Reset Password',
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _passwordresetRequest() async {
    var res;
    var data = {"new_password": _newpassword, "token": _code};
    print('reset data $data');
    var url='http://3.249.109.162:8080/api/auth/users/change-password/$resetemail';
    setState(() {
      _isLoading = true;
      //accesstoken=null;
    });
    if (!_formkey.currentState.validate()) {
      showToast(context, 'Enter valid details');
      setState(() {
      _isLoading = false;
      //accesstoken = res;
    });
      return;
    } else {
      _formkey.currentState.save();
      try {
         res = await resetPassword(data, url)
            .timeout(const Duration(seconds: 30));
        var body = json.decode(res.body);
        print('reset success response: $body');
        if (res.statusCode==200) {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: ResetSuccess(), type: PageTransitionType.slideInRight));
          showToast(context, '${body['message']}');
        } else {
          showToast(context, '${body['message']}');
        }
      } on TimeoutException {
        showToast(context, 'Error: time out');
      } on SocketException {
        showToast(context, 'Error: cannot find server');
      }
    }

    setState(() {
      _isLoading = false;
      //accesstoken = res;
    });
  }
}
