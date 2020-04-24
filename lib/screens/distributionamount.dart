import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:random_color/random_color.dart';
import 'package:walletmanager/apis/getcategories.dart';
import 'package:walletmanager/apis/httprequestsapis.dart';
import 'package:walletmanager/widgets/commonwidgets.dart';

class DistroAmount extends StatefulWidget {
  @override
  _DistroAmountState createState() => _DistroAmountState();
}

class _DistroAmountState extends State<DistroAmount> {
  final _formkey = GlobalKey<FormState>();
  String amount;
  bool _selectedtransaction = false;
  String _accname;
  int distroamt;
  bool _isLoading=false;
  String accountid;

  addDistroRate() async {
    setState(() {
      _isLoading = true;
    });
     if (!_formkey.currentState.validate()) {
          showToast(context, 'Enter valid details');
        return;
      }
      _formkey.currentState.save();
    var data = {"account_id": accountid, "amount": distroamt};

    print('ditro data $data');
    var res = await postData(data, 'income-distribution');
    print('response is ${res.body}');
    var body=json.decode(res.body);
    if (res.statusCode == 201) {
      showToast(context, 'Amount has been successfully distributed');
    } else {
      showToast(context, '${body['message']}');
    }

    setState(() {
      _isLoading = false;
       _selectedtransaction = false;
    });
  }

  Widget _buildItemsIncome(
      BuildContext context, List<Category> data, int index) {
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
              setState(() {
                _selectedtransaction = true;
                _accname=data[index].accountname;
                accountid=data[index].accountid;
              });
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
      body: SafeArea(
          child: SingleChildScrollView(
                      child: Container(
        //height: MediaQuery.of(context).size.height * 0.75,

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
                                color: Colors.red[600], size: size.setWidth(60)),
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
                          'Distribution Amount',
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
              Form(
                key: _formkey,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  // padding: MediaQuery.of(context).viewInsets,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: size.setHeight(40),
                      ),
                      Text(
                        'Enter amount to distribute',
                        style: TextStyle(
                            fontSize: size.setSp(24),
                            fontWeight: FontWeight.w600,
                            color: Colors.black87),
                      ),
                      
                      Stack(children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: size.setHeight(200),
                          child: FutureBuilder<List<Category>>(
                              future: fetchCategories('Income'),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) print(snapshot.error);
                                return snapshot.hasData
                                    ? ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        physics: const ClampingScrollPhysics(),
                                        itemCount: snapshot.data.length,
                                        // itemExtent: 10.0,
                                        // reverse: true, //makes the list appear in descending order
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return _buildItemsIncome(
                                              context, snapshot.data, index);
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

                       SizedBox(height: size.setHeight(20),),
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                size.setWidth(30),
                                size.setWidth(20),
                                size.setWidth(30),
                                size.setWidth(20)),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value.isEmpty) return 'Enter amount value';
                              },
                              onChanged: (value) {
                                //double _value = double.parse(value);
                                distroamt = int.parse(value);
                                // updatedAmount(state, _value);
                              },
                              style: TextStyle(
                                  fontSize: size.setSp(24),
                                  color: Colors.black87),
                              decoration: InputDecoration(
                                  labelText: 'Amount',
                                  border: OutlineInputBorder()),
                            ),
                          ),
                           SizedBox(height: size.setHeight(40),),
                          SizedBox(
                            height: size.setHeight(100),
                            width: size.setWidth(350),
                            child: Builder(
                              builder: (context) => FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        size.setWidth(20)),
                                    side: BorderSide(color: Colors.red)),
                                color: Colors.red,
                                onPressed: () async {
                                  await addDistroRate();
                                  
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
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
        ),
      ),
          )),
    );
  }
}
