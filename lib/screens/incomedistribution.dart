import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:walletmanager/apis/httprequestsapis.dart';
import 'package:walletmanager/widgets/commonwidgets.dart';

class IncomeDistro extends StatefulWidget {
  final String accoudid;
  IncomeDistro(this.accoudid);
  @override
  _IncomeDistroState createState() => _IncomeDistroState();
}

class _IncomeDistroState extends State<IncomeDistro> {
  bool _isLoading = false;
  int distrorate;

  addDistroRate() async {
    setState(() {
      _isLoading = true;
    });
    var data = {"account_id": widget.accoudid, "amount": distrorate};
    var res = await postData(data, 'income-distribution');
    print('response is ${res.body}');
    if (res.statusCode == 201) {
      showToast(context, 'Amount has been successfully distributed');
    } else {
      showToast(context, 'Unable to distribute amount');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1280, allowFontScaling: false);
    var size = ScreenUtil();
    return Card(
      child: Container(
        height: size.setHeight(300),
        padding: EdgeInsets.all(size.setWidth(15)),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: size.setHeight(20),
            ),
            Text(
              'Enter amount to distribe',
              style:
                  TextStyle(fontSize: size.setSp(28), color: Colors.grey[900]),
            ),
            SizedBox(
              height: size.setHeight(20),
            ),
            SizedBox(
              height: size.setHeight(100),
              width: size.setWidth(550),
              child: TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  distrorate = int.parse(value);
                },
                decoration: InputDecoration(
                    labelText: 'Amount to distribute',
                    border: OutlineInputBorder()),
              ),
            ),
            SizedBox(
              height: size.setHeight(30),
            ),
            SizedBox(
              height: size.setHeight(80),
              width: size.setWidth(300),
              child: Builder(
                builder: (context) => FlatButton(
                  disabledColor: Colors.red[600],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(size.setWidth(20)),
                      side: BorderSide(color: Colors.red)),
                  color: Colors.red,
                  onPressed: _isLoading
                      ? null
                      : () async {
                          await addDistroRate();
                          Navigator.of(context).pop();
                          //  Navigator.pushReplacement(context,
                          //  PageTransition(child: Home(), type: PageTransitionType.fadeIn)
                          //   );
                        },
                  child: _isLoading
                      ? spinkitwhite
                      : Text(
                          'DISTRIBUTE',
                          style: TextStyle(
                              fontSize: size.setSp(24), color: Colors.white),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
