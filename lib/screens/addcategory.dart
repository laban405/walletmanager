import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:walletmanager/apis/httprequestsapis.dart';
import 'package:walletmanager/screens/categories.dart';

class AddCategory extends StatefulWidget {
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  String accountcode;
  String accountname;
  String iconname;
  String mainaccount = 'Income';

  GlobalKey<FormState> _formkey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    print('accout catgory>>>$accountcategory');
    if (accountcategory == 0) {
      setState(() {
        mainaccount = 'Income';
      });
    } else if (accountcategory == 1) {
      setState(() {
        mainaccount = 'Expense';
      });
    }
    super.initState();
  }

  void showToast(String message) {
    Fluttertoast.showToast(
        msg: '$message',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white);
  }

  createCategory() async {
    if (!_formkey.currentState.validate()) {
      //  showToast(context, 'Enter valid details');
      return;
    }
    _formkey.currentState.save();
    var data = {
      "account_code": accountcode,
      "account_name": accountname,
      "icon_name": 'sample',
      "main_account": mainaccount
    };
    //print('data is >>>>>>>.$data');

    var res = await postData(data, 'account');

    Navigator.pushReplacement(
        context,
        PageTransition(
            child: Categories(), type: PageTransitionType.slideInLeft));
    //print('response add cat ${res.body}');
    showToast('Account added successfully');
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1280, allowFontScaling: false);
    var size = ScreenUtil();
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(size.setWidth(10)),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: size.setHeight(40),
                  ),
                  Text(
                    'Create new account',
                    style: TextStyle(
                        fontSize: size.setSp(28), color: Colors.black),
                  ),
                  SizedBox(
                    height: size.setHeight(20),
                  ),
                  Center(
                    child: ToggleSwitch(
                      cornerRadius: size.setWidth(10),
                      minWidth: size.setWidth(250),
                      initialLabelIndex: accountcategory,
                      activeBgColor: Colors.red[600],
                      activeTextColor: Colors.white,
                      inactiveBgColor: Colors.grey[200],
                      inactiveTextColor: Colors.red[600],
                      labels: ['INCOME', 'EXPENSE'],
                      onToggle: (index) {
                        // _selectedtransaction = false;
                        setState(() {
                          accountcategory = index;
                        });
                        if (accountcategory == 0) {
                          setState(() {
                            mainaccount = 'Income';
                          });
                        } else if (accountcategory == 1) {
                          setState(() {
                            mainaccount = 'Expense';
                          });
                        }
                        print(
                            'switched to: $index and acct cat $accountcategory');
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        size.setWidth(30),
                        size.setWidth(40),
                        size.setWidth(30),
                        size.setWidth(20)),
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          accountname = value;
                        });
                      },
                      decoration: InputDecoration(
                          labelText: 'Account Name',
                          border: OutlineInputBorder()),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        size.setWidth(30),
                        size.setWidth(40),
                        size.setWidth(30),
                        size.setWidth(40)),
                    child: TextFormField(
                      validator: (value) {
                        // if(value.length<3){
                        //   return ''
                        // }
                      },
                      onChanged: (value) {
                        accountcode = value;
                      },
                      decoration: InputDecoration(
                          labelText: 'Account code',
                          border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(
                    height: size.setHeight(100),
                    width: size.setWidth(350),
                    child: Builder(
                      builder: (context) => FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(size.setWidth(20)),
                            side: BorderSide(color: Colors.red)),
                        color: Colors.red,
                        onPressed: () {
                          createCategory();
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(
                              fontSize: size.setSp(24), color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
