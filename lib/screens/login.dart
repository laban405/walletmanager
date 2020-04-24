import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:walletmanager/apis/httprequestsapis.dart';
import 'package:walletmanager/screens/Home.dart';
import 'package:walletmanager/screens/register.dart';
import 'package:walletmanager/screens/resetpassword/emailreset.dart';
import 'package:walletmanager/widgets/commonwidgets.dart';

import '../constants.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _username;
  String _password;
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
                      height: size.setHeight(100),
                      width: size.setWidth(30),
                      color: Colors.red[600],
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Wallet Manager',
                      style: TextStyle(
                          fontSize: size.setSp(60),
                          color: Colors.red[600],
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    size.setWidth(90), size.setWidth(90), size.setWidth(90), 0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Login',
                        style: TextStyle(
                            fontSize: size.setSp(40),
                            color: Colors.black87,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: size.setHeight(60),
                      ),
                      SizedBox(
                        height: size.setHeight(120),
                        width: size.setWidth(550),
                        child: TextFormField(
                          onSaved: (value) {
                            _username = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your username';
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
                            labelText: 'Username',
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
                      SizedBox(
                        height: size.setHeight(120),
                        width: size.setWidth(550),
                        child: TextFormField(
                          obscureText: true,
                          onSaved: (value) {
                            _password = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your password';
                            }
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.grey[50],
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            labelText: 'Password',
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
                        height: size.setHeight(30),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.push(context, PageTransition(child: EmailReset(), type: PageTransitionType.slideInRight));
                        },
                                              child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'Forgot password? ',
                              style: TextStyle(
                                  fontSize: size.setSp(22),
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              ' Click here',
                              style: TextStyle(
                                  fontSize: size.setSp(22),
                                  color: Colors.red[600],
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
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
                              onPressed:_isLoading? null: () async {
                                await _loginRequest();
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Not registered?',
                            style: TextStyle(
                                fontSize: size.setSp(22),
                                color: Colors.black87,
                                fontWeight: FontWeight.w500),
                          ),
                          InkWell(
                            splashColor: Colors.red[600],
                            onTap: () {
                              Navigator.of(context).push(PageTransition(
                                  duration: Duration(milliseconds: 500),
                                  type: PageTransitionType.rippleLeftUp,
                                  child: Register()));
                            },
                            child: SizedBox(
                              height: size.setHeight(80),
                              width: size.setWidth(150),
                              child: Center(
                                child: Text(
                                  'Register here',
                                  style: TextStyle(
                                      fontSize: size.setSp(22),
                                      color: Colors.red[400],
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ],
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

  _loginRequest() async {
    var res;
    setState(() {
      _isLoading = true;
      accesstoken=null;
    });
    if (!_formkey.currentState.validate()) {
      showToast(context, 'Enter valid details');
      return;
    }
    _formkey.currentState.save();
    try{
     res = await requestToken(_username, _password)
        .timeout(const Duration(seconds: 30));
    //print('access token response: $res');
   if(res!=null){
    Navigator.push(context,
        PageTransition(child: Home(), type: PageTransitionType.slideInRight));
    showToast(context, 'Login successful');
    
  } else{
    showToast(context, 'Wrong login credentials');
  }
  } on TimeoutException{
    showToast(context, 'Error: time out');
  }on SocketException{
    showToast(context, 'Error: cannot find server');
  }

  setState(() {
      _isLoading = false;
      accesstoken=res;
    });
  }
}
