import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:random_color/random_color.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:walletmanager/apis/constants.dart';
import 'package:walletmanager/apis/distributionrateapi.dart';
import 'package:walletmanager/apis/httprequestsapis.dart';
import 'package:walletmanager/widgets/commonwidgets.dart';

class DistroRates {
  String accountid;
  String rate;
  int initialindex;

  DistroRates({this.accountid, this.rate, this.initialindex});
}

class DistributionRate extends StatefulWidget {
  @override
  _DistributionRateState createState() => _DistributionRateState();
}

class _DistributionRateState extends State<DistributionRate> {
  List distributionrates4 = new List();
  DistroRates distroRates = DistroRates();
  List incomeaccdata = List();
  List<DropdownMenuItem> items = [
    DropdownMenuItem(
      child: Text('wordPair'),
      value: 'wordPair',
    )
  ];

  String selectedincomename;
  bool _isLoading = false;
  Future _futuredistro;

  ///init state
  @override
  void initState() {
    super.initState();
    getIncomeAccounts();
  }

  _postRates(String incomeAcc) async {
    setState(() {
      _isLoading = true;
    });

    var res = await postData(
        distributionrates4, 'distribution-percentage/$incomeAcc');
    var decode = json.decode(res.body);

    if (res.statusCode == 200) {
      showToast(context, 'Rates set successfully');
    } else {
      showToast(context, '${decode['message']}');
    }

    setState(() {
      _isLoading = false;
    });
  }

  _addRates(int distrorateid, String value) async {
    var item = {
      "distribution_rate": value,
      "distribution_rate_id": distrorateid,
    };
    print(' item details $item');

    if (distributionrates4.isNotEmpty) {
      print('not empty');
      // print('acc id $accid');

      distributionrates4 = List.from(distributionrates4
          .where((element) => element["distribution_rate_id"] != distrorateid));
    }

    distributionrates4.add(item);
  }

  Future<String> getIncomeAccounts() async {
    var response = await getData('account?mainAccount=Income');
    var content = json.decode(response.body);
    setState(() {
      incomeaccdata = content;
    });
    return "Success";
  }

  DropdownButtonHideUnderline _incomeAccounts() {
    ScreenUtil.init(context, width: 720, height: 1500, allowFontScaling: false);
    var size = ScreenUtil();
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        iconEnabledColor: Colors.green,
        iconDisabledColor: Colors.red,
        isExpanded: true,
        hint: Text(
          "Select",
          style: TextStyle(
              fontSize: size.setSp(28),
              fontWeight: FontWeight.w600,
              color: Colors.red[600]),
        ),
        value: selectedincomename,
        isDense: true,
        onChanged: (newValue) {
          setState(() {
            //selecteduncomename = null;
            selectedincomeid = newValue;
            selectedincomename = newValue;
            _futuredistro = fetchDistro(selectedincomeid);
            distributionrates4 = distroratebody;
            // _type = getTypes(selectedcategory);
          });
        },
        items: incomeaccdata.map((map) {
          setState(() {
            accName = map['account_name'];
          });
          return DropdownMenuItem(
            value: map['account_id'].toString(),
            child: Text(accName,
                style: TextStyle(
                    fontSize: size.setSp(28),
                    fontWeight: FontWeight.w600,
                    color: Colors.greenAccent[700])),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildItemsExpense(
      BuildContext context, List<DistributionData> data, int index) {
    // List<Category> _data=List<Category>();
    RandomColor _randomColor = RandomColor();
    Color _color = _randomColor.randomColor(
        colorHue: ColorHue.random, colorBrightness: ColorBrightness.random);
    ScreenUtil.init(context, width: 720, height: 1280, allowFontScaling: false);
    var size = ScreenUtil();

    return Container(
        // color: Colors.blue,
        padding: EdgeInsets.all(size.setWidth(5)),
        color: Colors.grey[100],
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  left: BorderSide(
                      color: Colors.red[600], width: size.setWidth(10)))),
          height: size.setHeight(120),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: size.setWidth(15),
              ),
              Container(
                padding: EdgeInsets.all(size.setWidth(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: size.setWidth(330),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Icon(
                            Icons.account_balance_wallet,
                            color: _color,
                            size: size.setWidth(60),
                          ),
                          SizedBox(
                            width: size.setWidth(5),
                          ),
                          Padding(
                            padding: EdgeInsets.all(size.setWidth(5)),
                            child: Text(
                              data[index].accountName,
                              style: TextStyle(
                                  fontSize: size.setSp(24),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      width: size.setWidth(300),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            SizedBox(
                              height: size.setHeight(25),
                            ),
                            SizedBox(
                              height: size.setHeight(80),
                              width: size.setWidth(120),
                              child: TextField(
                                maxLength: 3,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                    fontSize: size.setSp(32)),
                                onChanged: (value) {
                                  print('value $value');
                                  distroRates.accountid =
                                      data[index].distroRateID;
                                  distroRates.rate = value;
                                  distroRates.initialindex = index;

                                  _addRates(int.parse(data[index].distroRateID),
                                      value);
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(5.0),
                                    counter: SizedBox.shrink(),
                                    // counter: '',
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey[300]),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey[300]),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey[300]),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey[300]),
                                    ),
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black54,
                                        fontSize: size.setSp(32)),
                                    hintText: '${data[index].distroRate}'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: size.setHeight(100),
                    //   width: size.setWidth(100),
                    //   child: Text(
                    //     '%',
                    //     // style: TextStyle(
                    //     //   fontSize:size.setSp(24) ,
                    //     //   color: Colors.black87
                    //     // ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1280, allowFontScaling: false);
    var size = ScreenUtil();
    return Scaffold(
      //backgroundColor: Colors.grey[200],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          elevation: 5,
          //shape: ShapeBorder(),
          backgroundColor: Colors.red[600],
          icon: Icon(Icons.save),
          label: _isLoading ? spinkitwhite : Text("Update"),
          onPressed: _isLoading
              ? null
              : () async {
                  await _postRates(selectedincomeid);
                  _futuredistro = fetchDistro(selectedincomeid);
                  //  clearTextInput();

                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: DistributionRate(),
                          type: PageTransitionType.fadeIn));
                }),
      body: SafeArea(
        child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.black45,
                          blurRadius: 1.0,
                          offset: Offset(0.0, .5))
                    ],
                  ),
                  height: size.setHeight(100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                                  color: Colors.red[600],
                                  size: size.setWidth(60)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            'Distribution Rate',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: size.setSp(32),
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      Expanded(flex: 1, child: Container())
                    ],
                  ),
                ),
                SizedBox(
                  height: size.setWidth(10),
                ),
                Card(
                  elevation: 2,
                  child: Container(
                      height: size.setHeight(100),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: size.setWidth(10),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Select income account first',
                              style: TextStyle(
                                  fontSize: size.setSp(26),
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: _incomeAccounts(),
                          )
                        ],
                      )),
                ),
                Expanded(
                  child: FutureBuilder<List<DistributionData>>(
                      future: _futuredistro,
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
                                  return _buildItemsExpense(
                                    // state,
                                    context,
                                    snapshot.data,
                                    index,
                                  );
                                })
                            : Center(
                                child: SizedBox(
                                  height: size.setHeight(200),
                                  width: size.setHeight(200),
                                  child: Container(),
                                ),
                                // CircularProgressIndicator(
                                //   backgroundColor: Colors.red[600],
                                //   valueColor: AlwaysStoppedAnimation<Color>(
                                //       Colors.white),
                                // ),
                              );
                      }),
                ),
              ],
            )),
      ),
    );
  }
}
