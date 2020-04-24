import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:walletmanager/apis/accounttransactionsapi.dart';
import 'package:walletmanager/apis/constants.dart';
import 'package:walletmanager/apis/httprequestsapis.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:walletmanager/screens/addcategory.dart';

import 'categories.dart';
import 'incomedistribution.dart';

class ShowDistroPercentage extends StatefulWidget {
  final String accountid;
  final String accountname;
  final String mainact;

  ShowDistroPercentage(this.accountid, this.accountname, this.mainact);

  @override
  _ShowDistroPercentageState createState() => _ShowDistroPercentageState();
}

class _ShowDistroPercentageState extends State<ShowDistroPercentage> {
  int accperiod = 0;

  Future<List<AccTransactionApi>> _future;

  Future _futureMonths;
  Future _futureaccbalance;
  @override
  void initState() {
    super.initState();
    _future = fetchAccTransaction(widget.accountid, accperiod);
    _futureMonths = accountmonths();
    _futureaccbalance = fetchAccBalance(widget.accountid, accperiod);
  }

  int _selectedIndex;
  _onSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void showErrorToast(String message) {
    Fluttertoast.showToast(
        msg: '$message',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        //timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void showSuccessToast(String message) {
    Fluttertoast.showToast(
        msg: '$message',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        //timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _showDialog(accountid, accountName) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title:
              new Text("Do you really want to delete account $accountName ?"),
          content: new Text(
              "Please note! You cannot delete an account that has already transacted!"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () async {
                Navigator.of(context).pop();
                deleteData('account/$accountid').then((resp) {
                  if (resp.statusCode != 200) {
                    final body = json.decode(resp.body);
                    showErrorToast(body['message']);
                    return;
                    //print(body['message']);
                  }
                  // print('Line 100');
                  showSuccessToast('Successfully deleted account $accountName');
                  // print('Line 102');

                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: Categories(),
                          type: PageTransitionType.slideInLeft));
                });
                // print('Line 110');
// }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1280, allowFontScaling: false);
    var size = ScreenUtil();

    Widget _buildItems(
      int index,
      data,
    ) {
      String period = (index + 1).toString();

      // Colors color1, Color color2
      return Container(
        // color: Colors.blue,
        padding: EdgeInsets.all(size.setWidth(5)),
        child: Row(children: [
          InkWell(
            onTap: () {
              setState(() {
                accperiod = int.parse(period);
                _future = fetchAccTransaction(widget.accountid, accperiod);
                _futureMonths = accountmonths();
                _futureaccbalance =
                    fetchAccBalance(widget.accountid, accperiod);
              });
              _onSelected(index);
            },
            child: Container(
                decoration: BoxDecoration(
                    color: _selectedIndex != null && _selectedIndex == index
                        ? Colors.red[600]
                        : Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.red[600])),
                width: size.setWidth(100),
                height: size.setHeight(80),
                child: Center(
                    child: Text("$data",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: size.setSp(28),
                          color:
                              _selectedIndex != null && _selectedIndex == index
                                  ? Colors.white
                                  : Colors.red[600],
                        )))),
          ),
        ]),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false, // set it to false
      body: SafeArea(
        child: Container(
          color: Colors.grey[100],
          child: Column(
            children: <Widget>[
              Material(
                elevation: 2,
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding:
                              EdgeInsets.fromLTRB(size.setWidth(15), 0, 0, 0),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back,
                                color: Colors.black87, size: size.setWidth(50)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child: Center(
                            child: Text(
                          '${widget.accountname}',
                          style: TextStyle(
                              fontSize: size.setSp(26),
                              fontWeight: FontWeight.w700,
                              color: Colors.black87),
                        ))),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: size.setHeight(100),
                        child: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: size.setWidth(50),
                          ),
                          onPressed: () {
                            _showDialog(widget.accountid, widget.accountname);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: widget.mainact == 'Expense'
                          ? Container(
                              child: SizedBox(height: size.setHeight(100)),
                            )
                          : SizedBox(
                              height: size.setHeight(100),
                              child: IconButton(
                                icon: Icon(
                                  Icons.save_alt,
                                  color: Colors.blue,
                                  size: size.setWidth(60),
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                          size.setWidth(40),
                                          size.setWidth(450),
                                          size.setWidth(40),
                                          size.setWidth(450),
                                        ),
                                        child: IncomeDistro(accountid),
                                      ));
                                },
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 1,
                child: Container(
                  height: size.setHeight(220),
                  child: FutureBuilder<AccTransactionData>(
                      future: _futureaccbalance,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) print(snapshot.error);
                        return snapshot.hasData
                            ? Container(
                                padding: EdgeInsets.all(size.setWidth(20)),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                'Balance',
                                                style: TextStyle(
                                                  fontSize: size.setSp(22),
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                'KES ${snapshot.data.balance}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: size.setSp(34),
                                                  color: Colors.black87,
                                                ),
                                              ),
                                              SizedBox(
                                                height: size.setHeight(10),
                                              ),
                                              Text(
                                                'Periodic balance ',
                                                style: TextStyle(
                                                  fontSize: size.setSp(22),
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                'KES ${snapshot.data.periodicbalance}',
                                                style: TextStyle(
                                                    fontSize: size.setSp(34),
                                                    color: Colors.black87,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: size.setHeight(10),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text('Total Debit',
                                                  style: TextStyle(
                                                    fontSize: size.setSp(22),
                                                    color: Colors.grey,
                                                  )),
                                              Text(
                                                'KES ${snapshot.data.totaldebit}',
                                                style: TextStyle(
                                                    fontSize: size.setSp(26),
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              SizedBox(
                                                height: size.setHeight(10),
                                              ),
                                              Text(
                                                'Total credit',
                                                style: TextStyle(
                                                  fontSize: size.setSp(22),
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                'KES ${snapshot.data.totalcredit}',
                                                style: TextStyle(
                                                  fontSize: size.setSp(26),
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: size.setHeight(10),
                                      ),
                                    ]),
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.red[600],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              );
                      }),
                ),
              ),
              Card(
                elevation: 1,
                child: Container(
                  height: size.setHeight(150),
                  // width: size.setWidth(400),
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
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return _buildItems(
                                            index, snapshot.data[index]);
                                      })
                                  : Center(
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.red[600],
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    );
                            }),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Expanded(
                  child: FutureBuilder<List<AccTransactionApi>>(
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
                                  if (snapshot.data[index].entrytype ==
                                      'Debit') {
                                    _color = Colors.red[600];
                                  } else {
                                    _color = Colors.green;
                                  }
                                  return Container(
                                      margin: EdgeInsets.all(size.setWidth(20)),
                                      height: size.setHeight(100),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[300],
                                                  width: size.setWidth(2)))),
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(
                                            width: size.setWidth(50),
                                            child: Icon(
                                              Icons.account_balance_wallet,
                                              size: size.setWidth(50),
                                              color: Colors.black54,
                                            ),
                                          ),
                                          SizedBox(
                                            width: size.setWidth(20),
                                          ),
                                          SizedBox(
                                            width: size.setWidth(250),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  'KES ${snapshot.data[index].amount}',
                                                  style: TextStyle(
                                                      color: _color,
                                                      fontSize: size.setSp(28),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                Text(
                                                  '${snapshot.data[index].narration}',
                                                  style: TextStyle(
                                                      color: Colors.grey[600],
                                                      fontSize: size.setSp(18),
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: size.setWidth(250),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Text(
                                                  '${snapshot.data[index].date}',
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize: size.setSp(22),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ));
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
