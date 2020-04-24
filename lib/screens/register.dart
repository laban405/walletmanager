import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:walletmanager/apis/httprequestsapis.dart';
import 'package:walletmanager/constants.dart';
import 'package:walletmanager/screens/login.dart';
import 'package:walletmanager/widgets/commonwidgets.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  List<double> _stops = [0.0, 0.9];

  String name;
  String username;
  String email;
  String password;
  String confirmpassword;
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
                padding: EdgeInsets.fromLTRB(size.setWidth(90),
                    size.setWidth(30), size.setWidth(90), size.setWidth(40)),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: size.setHeight(80),
                      width: size.setWidth(20),
                      color: Colors.red[600],
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Wallet Manager',
                      style: TextStyle(
                          fontSize: size.setSp(40),
                          color: Colors.red[600],
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    size.setWidth(90), 0, size.setWidth(90), 0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Register',
                        style: TextStyle(
                            fontSize: size.setSp(40),
                            color: Colors.black87,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: size.setHeight(30),
                      ),
                      SizedBox(
                        height: size.setHeight(120),
                        width: size.setWidth(550),
                        child: TextFormField(
                          onSaved: (value) {
                            name = value;
                          },
                          validator: (value) {
                            if ( value.length <4) 
                              return 'Please enter a name with 4 or more characters';
                            else return null;
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.grey[50],
                            filled: true,
                            //focusColor: Colors.black,
                            focusedBorder: OutlineInputBorder(
                              // borderRadius:
                              //     BorderRadius.circular(size.setWidth(50)),
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              // borderRadius:
                              //     BorderRadius.circular(size.setWidth(50)),
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            enabledBorder: OutlineInputBorder(
                              // borderRadius:
                              //     BorderRadius.circular(size.setWidth(50)),
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            hintText: 'Name',
                            labelStyle: TextStyle(
                                fontSize: size.setSp(24),
                                color: Colors.grey[700]),
                            errorStyle: TextStyle(
                              fontSize: size.setSp(22),
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
                            username = value;
                          },
                          validator: (value) {
                            
                             if ( value.length <4) 
                              return 'Please enter a username with 4 or more characters';
                            else return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: size.setHeight(20),
                                horizontal: size.setWidth(20)),
                            fillColor: Colors.grey[50],
                            filled: true,
                            //focusColor: Colors.black,
                            focusedBorder: OutlineInputBorder(
                              // borderRadius:
                              //     BorderRadius.circular(size.setWidth(50)),
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              // borderRadius:
                              //     BorderRadius.circular(size.setWidth(50)),
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            enabledBorder: OutlineInputBorder(
                              // borderRadius:
                              //     BorderRadius.circular(size.setWidth(50)),
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            labelText: 'Username',
                            labelStyle: TextStyle(
                                fontSize: size.setSp(24),
                                color: Colors.grey[700]),
                            errorStyle: TextStyle(
                              fontSize: size.setSp(22),
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
                            email = value;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your email';
                            }

                            if (!RegExp(
                                    r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                .hasMatch(value)) {
                              return 'Please enter a valid email Address';
                            }
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.grey[50],
                            filled: true,
                            // focusColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              // borderRadius:
                              //     BorderRadius.circular(size.setWidth(50)),
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              // borderRadius:
                              //     BorderRadius.circular(size.setWidth(50)),
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            enabledBorder: OutlineInputBorder(
                              // borderRadius:
                              //     BorderRadius.circular(size.setWidth(50)),
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            labelText: 'Email',
                            labelStyle: TextStyle(
                                fontSize: size.setSp(24),
                                color: Colors.grey[700]),
                            errorStyle: TextStyle(
                              fontSize: size.setSp(22),
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
                            password = value;
                          },
                          validator: ( String value) {
                            if ( value.length <4) 
                              return 'Enter password length between 4 and 20 characters';
                            else return null;
                          },
                          decoration: InputDecoration(
                            // contentPadding: EdgeInsets.symmetric(
                            //     vertical: size.setHeight(20),
                            //     horizontal: size.setWidth(20)),
                            fillColor: Colors.grey[50],
                            filled: true,
                            //focusColor: Colors.black,
                            focusedBorder: OutlineInputBorder(
                              // borderRadius:
                              //     BorderRadius.circular(size.setWidth(50)),
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              // borderRadius:
                              //     BorderRadius.circular(size.setWidth(50)),
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            enabledBorder: OutlineInputBorder(
                              // borderRadius:
                              //     BorderRadius.circular(size.setWidth(50)),
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(
                                fontSize: size.setSp(24),
                                color: Colors.grey[700]),
                            errorStyle: TextStyle(
                              fontSize: size.setSp(22),
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
                            confirmpassword = value;
                          },
                          validator: (value) {
                            if (value != password) {
                              return 'Passwords don\'t match';
                            }
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.grey[50],
                            filled: true,
                            //focusColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              // borderRadius:
                              //     BorderRadius.circular(size.setWidth(50)),
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              // borderRadius:
                              //     BorderRadius.circular(size.setWidth(50)),
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            enabledBorder: OutlineInputBorder(
                              // borderRadius:
                              //     BorderRadius.circular(size.setWidth(50)),
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red[600]),
                            ),
                            labelText: 'Confirm password',
                            labelStyle: TextStyle(
                                fontSize: size.setSp(24),
                                color: Colors.grey[700]),
                            errorStyle: TextStyle(
                              fontSize: size.setSp(22),
                              color: Colors.red[600],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.setHeight(10),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            'Already have an account?',
                            style: TextStyle(
                                fontSize: size.setSp(22),
                                color: Colors.black87,
                                fontWeight: FontWeight.w500),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  PageTransition(
                                      curve: Curves.easeInCubic,
                                      duration: Duration(milliseconds: 500),
                                      type: PageTransitionType.rippleRightDown,
                                      child: Login()));
                            },
                            child: SizedBox(
                              height: size.setHeight(50),
                              width: size.setWidth(150),
                              child: Center(
                                child: Text(
                                  'Click to login',
                                  style: TextStyle(
                                      fontSize: size.setSp(22),
                                      color: Colors.red[600],
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.setHeight(20),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                      await _registerUser();
                                    },
                              child: _isLoading
                                  ? spinkitwhite
                                  : Text(
                                      'Register',
                                      style: TextStyle(
                                          fontSize: size.setSp(22),
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
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

  _registerUser() async {
    
    _formkey.currentState.save();
    if (!_formkey.currentState.validate()) {
      //  showToast(context, 'Enter valid details');
      return;
    }

    setState(() {
      _isLoading = true;
    });
    
  try{
    var data = {
      "email": email,
      "name": name,
      "password": password,
      "username": username,
    };
    print('data is $data');
    

    var res = await registerpostData(data, 'auth/signup').timeout(const Duration(seconds: 30));
    var body= json.decode(res.body);

    print('register response is ${res.body}');
    print('register response is ${res.statusCode}');
    if(res.statusCode==201){
    Navigator.push(context,
        PageTransition(child: Login(), type: PageTransitionType.slideInLeft));
    showToast(context, '${body['message']}');
    }
    else {
      showToast(context, '${body['message']}');
   }

  } on TimeoutException{
    showToast(context, 'Error: time out');
  } 


    
    setState(() {
      _isLoading = false;
    });
  }
}
