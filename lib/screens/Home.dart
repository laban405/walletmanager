import 'dart:convert';

import 'package:walletmanager/apis/constants.dart';
import 'package:walletmanager/apis/dashboardapi.dart';
import 'package:walletmanager/apis/getcategories.dart';
import 'package:walletmanager/apis/httprequestsapis.dart';
import 'package:walletmanager/screens/drawer.dart';
import 'package:walletmanager/widgets/commonwidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:intl/intl.dart';
import 'package:random_color/random_color.dart';
import 'package:toggle_switch/toggle_switch.dart';

GlobalKey<ScaffoldState> drawerKey = GlobalKey();
final scaffoldKey = GlobalKey<ScaffoldState>();

String _accountid;
double _amount;
String _date = DateFormat('yyyy-MM-dd').format(DateTime.now());
String _formatteddate = '20';
String _narration;
String _accname;

String _year;
String _month;
String _day;

String username;
String useremail;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool drawerenabled = true;
  bool _isexpensevisible = true;
  bool _isincomevisible = false;
  bool _selectedtransaction = false;
  int accperiod = 0;
  Future _futureMonths;
  Future _future;
  Future _futurebalance;

  @override
  void initState() {
    super.initState();
    getProfile();
    _future = fetchCategories2(accperiod);
    _futureMonths = accountmonths();
   _futurebalance = fetchBalance(accperiod.toString());
  }


  //profile

  getProfile()async{
    var res = await getData('auth/users/me');
    var body=json.decode(res.body);
    print('profile>>>>$body');
    setState(() {
      username=body['username'];
      useremail=body['email'];      
    });

  }

  Future<Null> updated(
      StateSetter updateState, bool _expense, bool _income) async {
    updateState(() {
      _isexpensevisible = _expense;
      _isincomevisible = _income;
    });
  }

  Future<Null> updatedNarration(
    StateSetter updateState,
    String narration,
  ) async {
    updateState(() {
      _narration = narration;
    });
  }

  Future<Null> updatedAmount(
    StateSetter updateState,
    double amount,
  ) async {
    updateState(() {
      _amount = amount;
    });
  }

  Future<Null> updatedSelected(StateSetter updateState) async {
    updateState(() {
      _selectedtransaction = false;
    });
  }

  Future<Null> updatedAccountId(StateSetter updateState, accountid) async {
    updateState(() {
      _accountid = accountid;
    });
  }

  Future<Null> updatedTransaction(
      StateSetter updateState, bool isSelected, String accname) async {
    updateState(() {
      _accname = accname;
      _selectedtransaction = true;
    });
  }

  Future<Null> updatedDateId(StateSetter updateState, String year, String month,
      String day, var date) async {
    updateState(() {
      _year = year;
      _month = month;
      _day = day;
      _date = '$_year - $_month - $_day';
      _formatteddate = DateFormat('yyyy-MM-dd').format(date);
      ;
      print('formatted $_formatteddate');
    });
  }

  Future<Null> updateFutures(StateSetter updateState) async {
    updateState(() {
      _future = fetchCategories2(accperiod);

      _futureMonths = accountmonths();
      _futurebalance = fetchBalance(accperiod.toString());
    });
  }

  void _showModalSheet() {
    ScreenUtil.init(context, width: 720, height: 1280, allowFontScaling: false);
    var size = ScreenUtil();
    //List<bool> _selection = List.generate(2, (_) => false);

    final _formkey = GlobalKey<FormState>();

    _doTransaction(String transactiontype) async {
      if (!_formkey.currentState.validate()) {
          showToast(context, 'Enter valid details');
        return;
      }
      _formkey.currentState.save();

      var data = {
        "amount": _amount,
        "narration": _narration,
        "date": _formatteddate,
        "account_id": _accountid,
        // "account_type": null,
        // "account_name": "Rent"
      };
      print('data is $data');
      var res = await postData(data, 'transaction/$transactiontype');
      if (res.statusCode == 201) {
        showToast(context, 'Transaction successful');
        //showSnackBar(context, 'Transaction successful');
      }

      print('response is ${res.statusCode}');
      print('response transaction>>>>is ${res.body}');
    }

    ///index for active month

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        //enableDrag: true,
        isDismissible: true,
        useRootNavigator: true,
        builder: (BuildContext ctx) {
          return StatefulBuilder(builder: (context, state) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Scaffold(
                resizeToAvoidBottomInset: true, // important
                key: scaffoldKey,
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  child: Form(
                    key: _formkey,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.75,
                      // padding: MediaQuery.of(context).viewInsets,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              SizedBox(
                                height: size.setHeight(20),
                              ),
                              Text(
                                'Add New Transaction',
                                style: TextStyle(
                                    fontSize: size.setSp(24),
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87),
                              ),
                              SizedBox(
                                height: size.setHeight(20),
                              ),
                              ToggleSwitch(
                                minWidth: size.setWidth(250),
                                initialLabelIndex: 0,
                                activeBgColor: Colors.red[600],
                                activeTextColor: Colors.white,
                                inactiveBgColor: Colors.grey[200],
                                inactiveTextColor: Colors.red[600],
                                labels: ['EXPENSE', 'INCOME'],
                                onToggle: (index) {
                                  _selectedtransaction = false;
                                  if (index == 0) {
                                    updated(state, true, false);
                                  } else {
                                    updated(state, false, true);
                                  }
                                  // print('switched to: $index');
                                },
                              ),
                              SizedBox(
                                height: size.setHeight(5),
                              ),
                            ],
                          ),
                          Stack(children: <Widget>[
                            Visibility(
                              visible: _isexpensevisible,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: size.setHeight(200),
                                child: FutureBuilder<List<Category>>(
                                    future: fetchCategories('Expense'),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError)
                                        print(snapshot.error);

                                      return snapshot.hasData
                                          ? ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              itemCount: snapshot.data.length,
                                              // itemExtent: 10.0,
                                              // reverse: true, //makes the list appear in descending order
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return _buildItemsExpense(
                                                    state,
                                                    context,
                                                    snapshot.data,
                                                    index);
                                              })
                                          : Center(
                                              child: CircularProgressIndicator(
                                                backgroundColor:
                                                    Colors.red[600],
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                              ),
                                            );
                                    }),
                              ),
                            ),
                            Visibility(
                              visible: _isincomevisible,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: size.setHeight(200),
                                child: FutureBuilder<List<Category>>(
                                    future: fetchCategories('Income'),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError)
                                        print(snapshot.error);
                                      return snapshot.hasData
                                          ? ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              itemCount: snapshot.data.length,
                                              // itemExtent: 10.0,
                                              // reverse: true, //makes the list appear in descending order
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return _buildItemsIncome(
                                                    state,
                                                    context,
                                                    snapshot.data,
                                                    index);
                                              })
                                          : Center(
                                              child: CircularProgressIndicator(
                                                backgroundColor:
                                                    Colors.red[600],
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                              ),
                                            );
                                    }),
                              ),
                            ),
                            Visibility(
                              visible: _selectedtransaction,
                              child: Container(
                                //color: Colors.yellow,
                                padding: EdgeInsets.all(size.setWidth(20)),
                                child: Container(
                                  // color: Colors.red,
                                  height: size.setHeight(160),
                                  width: size.setWidth(200),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                            right: BorderSide(
                                                color: Colors.grey[400]))),
                                    margin: EdgeInsets.all(size.setWidth(0)),
                                    padding: EdgeInsets.all(size.setWidth(5)),
                                    child: Center(
                                        child: Text(
                                      '$_accname',
                                      style: TextStyle(
                                          fontSize: size.setSp(24),
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87),
                                    )),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                          // SizedBox(height: size.setHeight(20),),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    size.setWidth(30),
                                    size.setWidth(20),
                                    size.setWidth(30),
                                    size.setWidth(20)),
                                child: TextFormField(
                                  onChanged: (value) {
                                    updatedNarration(state, value);
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Description (optional)',
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    size.setWidth(30),
                                    size.setWidth(20),
                                    size.setWidth(30),
                                    size.setWidth(20)),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if(value.isEmpty)
                                    return 'Enter amount value';
                                    
                                  },
                                  onChanged: (value) {
                                    double _value = double.parse(value);
                                    updatedAmount(state, _value);
                                  },
                                  style: TextStyle(
                                      fontSize: size.setSp(24),
                                      color: Colors.black87),
                                  decoration: InputDecoration(
                                      labelText: 'Amount',
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    size.setWidth(30),
                                    size.setWidth(20),
                                    size.setWidth(30),
                                    size.setWidth(40)),
                                child: InkWell(
                                  onTap: () {
                                    DatePicker.showDatePicker(context,
                                        theme: DatePickerTheme(
                                          //titleHeight: size.setHeight(60),
                                          doneStyle: TextStyle(
                                              fontSize: size.setSp(26),
                                              color: Colors.green),
                                          cancelStyle: TextStyle(
                                              fontSize: size.setSp(26),
                                              color: Colors.red[600]),
                                          containerHeight: size.setHeight(420),
                                        ),
                                        showTitleActions: true,
                                        minTime: DateTime(2020, 1, 1),
                                        maxTime: DateTime(2022, 12, 31),
                                        onConfirm: (date) {
                                      print('confirm $date');
                                      updatedDateId(state, '${date.year}',
                                          '${date.month}', '${date.day}', date);
                                      print('$_year - $_month - $_day');
                                    },
                                        currentTime: DateTime(2020, 04, 04),
                                        locale: LocaleType.en);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(size.setWidth(10)),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(size.setWidth(8))),
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.grey[500])),
                                    alignment: Alignment.center,
                                    height: size.setHeight(110),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.date_range,
                                                    size: 18.0,
                                                    color: Colors.red[600],
                                                  ),
                                                  Text(" $_date",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.grey[700],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              size.setSp(28))),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Text("  Change",
                                            style: TextStyle(
                                              color: Colors.red[500],
                                              fontWeight: FontWeight.bold,
                                              fontSize: size.setSp(28),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Stack(
                                children: <Widget>[
                                  Visibility(
                                    visible: _isincomevisible,
                                    child: SizedBox(
                                      height: size.setHeight(100),
                                      width: size.setWidth(350),
                                      child: Builder(
                                        builder: (context) => FlatButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      size.setWidth(20)),
                                              side: BorderSide(
                                                  color: Colors.red)),
                                          color: Colors.red,
                                          onPressed: () async {
                                            await _doTransaction('Credit');
                                            updateFutures(state);
                                            Navigator.of(context).pop();
                                            //  Navigator.pushReplacement(context,
                                            //  PageTransition(child: Home(), type: PageTransitionType.fadeIn)
                                            //   );
                                          },
                                          child: Text(
                                            'SUBMIT',
                                            style: TextStyle(
                                                fontSize: size.setSp(24),
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _isexpensevisible,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          height: size.setHeight(100),
                                          width: size.setWidth(150),
                                          child: Builder(
                                            builder: (context) => FlatButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          size.setWidth(20)),
                                                  side: BorderSide(
                                                      color: Colors.red)),
                                              color: Colors.red,
                                              onPressed: () async {
                                                await _doTransaction('Credit');
                                                Navigator.of(context).pop();
                                                updateFutures(state);
                                                //  Navigator.pushReplacement(context,
                                                //  PageTransition(child: Home(), type: PageTransitionType.fadeIn)
                                                //   );
                                              },
                                              child: Text(
                                                'IN',
                                                style: TextStyle(
                                                    fontSize: size.setSp(24),
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.setWidth(40),
                                        ),
                                        SizedBox(
                                          height: size.setHeight(100),
                                          width: size.setWidth(150),
                                          child: Builder(
                                            builder: (context) => FlatButton(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          size.setWidth(20)),
                                                  side: BorderSide(
                                                      color: Colors.red)),
                                              color: Colors.red,
                                              onPressed: () async {
                                                await _doTransaction('Debit');
                                                updateFutures(state);
                                                Navigator.of(context).pop();
                                                //  Navigator.pushReplacement(context,
                                                //  PageTransition(child: Home(), type: PageTransitionType.fadeIn)
                                                //   );
                                              },
                                              child: Text(
                                                'OUT',
                                                style: TextStyle(
                                                    fontSize: size.setSp(24),
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  int _selectedIndex;
  _onSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildItemsMonths(
    int index,
    data,
  ) {
    ScreenUtil.init(context, width: 720, height: 1280, allowFontScaling: false);
    var size = ScreenUtil();
    String period = (index + 1).toString();

    // Colors color1, Color color2
    return Container(
      // color: Colors.blue,
      padding: EdgeInsets.all(size.setWidth(5)),
      //height: size.setHeight(100),
      child: Row(children: [
        InkWell(
          onTap: () {
            setState(() {
              accperiod = int.parse(period);
             
              _futurebalance = fetchBalance(period);
               _future = fetchCategories2(accperiod);
              //fetchAccTransaction(widget.accountid, accperiod);
              _futureMonths = accountmonths();
            });
            _onSelected(index);
          },
          child: Container(
              decoration: BoxDecoration(
                  color: _selectedIndex != null && _selectedIndex == index
                      ? Colors.red[600]
                      : Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: _selectedIndex != null && _selectedIndex == index
                        ? Colors.red[600]
                        : Colors.black87,

                    // Colors.red[600]
                  )),
              width: size.setWidth(100),
              height: size.setHeight(80),
              child: Center(
                  child: Text("$data",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: size.setSp(28),
                        color: _selectedIndex != null && _selectedIndex == index
                            ? Colors.white
                            : Colors.black87,
                      )))),
        ),
      ]),
    );
  }

  Widget _buildItemsExpense(
      StateSetter state, BuildContext context, List<Category> data, int index) {
    // List<Category> _data=List<Category>();
    RandomColor _randomColor = RandomColor();
    Color _color =
        _randomColor.randomColor(colorBrightness: ColorBrightness.dark);
    ScreenUtil.init(context, width: 720, height: 1280, allowFontScaling: false);
    var size = ScreenUtil();

    return Container(
        // color: Colors.blue,
        padding: EdgeInsets.all(size.setWidth(20)),
        child: Container(
          height: size.setWidth(200),
          width: size.setWidth(200),
          //color: Colors.greenAccent,
          child: Container(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.red[600])),
            margin: EdgeInsets.all(size.setWidth(5)),
            padding: EdgeInsets.all(size.setWidth(5)),
            child: InkWell(
              onTap: () {
                updatedAccountId(state, data[index].accountid);
                updatedTransaction(state, true, data[index].accountname);
                print('account code ${data[index].accountid}');
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Icon(
                    Icons.account_balance_wallet,
                    color: _color,
                    size: size.setWidth(90),
                  ),
                  Padding(
                    padding: EdgeInsets.all(size.setWidth(5)),
                    child: Text(
                      data[index].accountname,
                      style: TextStyle(
                          fontSize: size.setSp(24),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildItemsIncome(
      StateSetter state, BuildContext context, List<Category> data, int index) {
    RandomColor _randomColor = RandomColor();
    Color _color =
        _randomColor.randomColor(colorBrightness: ColorBrightness.dark);
    ScreenUtil.init(context, width: 720, height: 1280, allowFontScaling: false);
    var size = ScreenUtil();
    return Container(
      // color: Colors.blue,
      padding: EdgeInsets.all(size.setWidth(20)),
      child: Container(
        height: size.setWidth(200),
        width: size.setWidth(200),
        //color: Colors.orangeAccent,
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.red[600])),
          margin: EdgeInsets.all(size.setWidth(5)),
          padding: EdgeInsets.all(size.setWidth(5)),
          child: InkWell(
            onTap: () {
              updatedAccountId(state, data[index].accountid);
              updatedTransaction(state, true, data[index].accountname);
              print('account code ${data[index].accountid}');
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(
                  Icons.account_balance_wallet,
                  color: _color,
                  size: size.setWidth(90),
                ),
                Padding(
                  padding: EdgeInsets.all(size.setWidth(5)),
                  child: Text(
                    data[index].accountname,
                    style: TextStyle(
                        fontSize: size.setSp(24), fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1280, allowFontScaling: false);
    var size = ScreenUtil();
    return Scaffold(
      //drawerEdgeDragWidth: 0,
      key: drawerKey,
      drawer: Drawer(
    child: drawerFunction(context),
      ),

      body: SafeArea(
          child: Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
          child: Container(
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    drawerKey.currentState.openDrawer();
                  },
                  child: Image.asset(
                    'assets/images/menu.png',
                    height: ScreenUtil().setWidth(80),
                    width: ScreenUtil().setWidth(80),
                    color: Colors.red[600],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
                  child: Text(
                    'Wallet Manager',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(36),
                        fontWeight: FontWeight.w700,
                        color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
        ),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(ScreenUtil().setHeight(20))),
          ),
          color: Colors.red[600],
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(ScreenUtil().setHeight(20))),
              gradient: LinearGradient(
                  colors: [Colors.red[800], Colors.red[600]],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter),
            ),
            padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
            height: ScreenUtil().setHeight(280),
            width: MediaQuery.of(context).size.width * .95,
            child: FutureBuilder<Map<String, dynamic>>(
                future: _futurebalance,
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? Container(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment:
                              //     MainAxisAlignment.start,
                              children: <Widget>[
                              Container(
                                height: size.setHeight(100),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'YOUR BALANCE',
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(20),
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            height: size.setHeight(10),
                                          ),
                                          Text(
                                            'KES. ${snapshot.data['wallet_balance']}',
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(40),
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(flex: 1, child: Container()),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'PERIODIC BALANCE',
                                            style: TextStyle(
                                                fontSize:
                                                    ScreenUtil().setSp(20),
                                                color: Colors.white60,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            height: size.setHeight(10),
                                          ),
                                          Text(
                                            'KES. ${snapshot.data['period_balance']}',
                                            style: TextStyle(
                                              fontSize: ScreenUtil().setSp(28),
                                              color: Colors.white70,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: size.setHeight(10),
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 3,
                                    child: Card(
                                        elevation: 0,
                                        color: Colors.red[400],
                                        child: Container(
                                            height:
                                                ScreenUtil().setHeight(100),
                                            width: ScreenUtil().setWidth(380),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  'Money In',
                                                  style: TextStyle(
                                                    fontSize: ScreenUtil()
                                                        .setSp(22),
                                                    color: Colors.white70,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  'KES. ${snapshot.data['total_income']}',
                                                  style: TextStyle(
                                                    fontSize: ScreenUtil()
                                                        .setSp(30),
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ))),
                                  ),
                                  Expanded(child: Container()),
                                  Expanded(
                                    flex: 3,
                                    child: Card(
                                        elevation: 0,
                                        color: Colors.red[400],
                                        child: Container(
                                            height:
                                                ScreenUtil().setHeight(100),
                                            width: ScreenUtil().setWidth(380),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  'Money Out',
                                                  style: TextStyle(
                                                    fontSize: ScreenUtil()
                                                        .setSp(22),
                                                    color: Colors.white70,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  'KES. ${snapshot.data['total_expense']}',
                                                  style: TextStyle(
                                                    fontSize: ScreenUtil()
                                                        .setSp(30),
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ))),
                                  ),
                                ],
                              )
                            ]))
                      : Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.red[600],
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        );
                }),
          ),
        ),
        Container(
          height: size.setHeight(100),
          padding: EdgeInsets.symmetric(horizontal: size.setWidth(30)),
          child: Row(
            children: <Widget>[
              Expanded(
                child: FutureBuilder<List>(
                    future: _futureMonths,
                    builder: (context, snapshot) {
                      if (snapshot.hasError)
                        print('errr>++++++++++>>${snapshot.error}');
                      return snapshot.hasData
                          ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount: 12,
                              // itemExtent: 10.0,
                              // reverse: true, //makes the list appear in descending order
                              itemBuilder: (BuildContext context, int index) {
                                return  _buildItemsMonths(
                                    index, snapshot.data[index]);
                              })
                          : Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.red[600],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            );
                    }),
              ),
            ],
          ),
        ),
        Column(children: <Widget>[
          Container(
              //color: Colors.amber,
              height: ScreenUtil().setHeight(700),
              width: MediaQuery.of(context).size.width * .88,
              child: FutureBuilder<List<DashBoardApi>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    return snapshot.hasData
          ? ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: snapshot.data.length,
              // itemExtent: 10.0,
              // reverse: true, //makes the list appear in descending order
              itemBuilder: (BuildContext context, int index) {
                Color _color;
                if (snapshot.data[index].transactionType ==
                    'Debit') {
                  _color = Colors.red[600];
                } else {
                  _color = Colors.green;
                }
                return 
                // snapshot.data[index].amount ==null? Container(
                //   height: size.setHeight(50),
                //  width: size.setHeight(50),
                //  color: Colors.green,
                //  child: Text('No data'),
                // ):
                Container(
                    height: size.setHeight(100),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey[300],
                                width: size.setWidth(2)))),
                    child:Row(
                      children: <Widget>[
                        Icon(
                          Icons.account_balance_wallet,
                          size: size.setWidth(40),
                        ),
                        SizedBox(
                          width: size.setWidth(40),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '${snapshot.data[index].accname}',
                                    style: TextStyle(
                                        fontSize: size.setSp(28),
                                        fontWeight:
                                            FontWeight.w600),
                                  ),
                                  
                                  Text(
                                    '${snapshot.data[index].narration}',
                                    style: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: size.setSp(18),
                                        fontWeight:
                                            FontWeight.w400),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          // width: size.setWidth(200),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.end,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    'KES ${snapshot.data[index].amount}',
                                    style: TextStyle(
                                        color: _color,
                                        fontSize: size.setSp(28),
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '${snapshot.data[index].date}',
                                    style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: size.setSp(18),
                                        fontWeight:
                                            FontWeight.w400),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ));
              })
          : Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.red[600],
                valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
                  }),
            ),
        ]),
      ],
    ),
      ),

      floatingActionButton: FloatingActionButton(
    onPressed: () {
      setState(() {
        _selectedtransaction = false;
        _isincomevisible = false;
        _isexpensevisible = true;
      });
      _showModalSheet();
    },
    backgroundColor: Colors.red[600],
    child: Icon(
      Icons.add,
      color: Colors.white,
      size: size.setWidth(80),
    ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
