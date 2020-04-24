
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:walletmanager/apis/constants.dart';
import 'package:walletmanager/apis/getcategories.dart';
import 'package:walletmanager/screens/Home.dart';
import 'package:walletmanager/screens/categories.dart';
import 'package:walletmanager/screens/individualtransaction.dart';

import 'cell.dart';

String _accountid;

//spinkit
final spinkitwhite = SpinKitThreeBounce(
  color: Colors.white,
  size: 20.0,
);
final spinkitblack = SpinKitThreeBounce(
  color: Colors.black,
  size: 20.0,
);

final spinkitred = SpinKitThreeBounce(
  color: Colors.red,
  size: 15.0,
);

void showToast(BuildContext context, String text) {
  ScreenUtil.init(context, width: 720, height: 1280, allowFontScaling: false);
  var size = ScreenUtil();
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIos: 1,
    backgroundColor: Colors.black87,
    textColor: Colors.white,
    fontSize: size.setSp(24),
  );
}

void showToastRed(BuildContext context, String text) {
  ScreenUtil.init(context, width: 720, height: 1280, allowFontScaling: false);
  var size = ScreenUtil();
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIos: 1,
    backgroundColor: Colors.red[600],
    textColor: Colors.white,
    fontSize: size.setSp(24),
  );
}

showSnackBar(BuildContext context, String message) {
  ScreenUtil.init(context, width: 720, height: 1280, allowFontScaling: false);
  var size = ScreenUtil();
  scaffoldKey.currentState
    ..showSnackBar(SnackBar(
      duration: Duration(
        seconds: 2,
      ),
      backgroundColor: Colors.black87,
      content: SizedBox(
        height: size.setHeight(130),
        child: Center(
          child: Text(
            '$message',
            style: TextStyle(color: Colors.white, fontSize: size.setSp(26)),
          ),
        ),
      ),
    ));
}

class ComComp {
  static Padding text(String text, FontWeight fontWeight, double fontSize,
      List padding, Color color, TextOverflow overflow) {
    return Padding(
      padding: new EdgeInsets.only(
          left: padding[0],
          right: padding[1],
          top: padding[2],
          bottom: padding[3]),
      child: Text(
        text,
        textAlign: TextAlign.left,
        overflow: overflow,
        style: TextStyle(
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: color,
        ),
      ),
    );
  }

  static AppBar getAppBar(Color color, String title) {
    return AppBar(
      backgroundColor: COLORS.APP_THEME_COLOR,
      title: Center(
        child: new Text(title.toUpperCase()),
      ),
      actions: <Widget>[],
    );
  }

  static circularProgress() {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.red[600],
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }

  static GestureDetector internetErrorText(Function callback) {
    return GestureDetector(
      onTap: callback,
      child: Center(
        child: Text(MESSAGES.INTERNET_ERROR),
      ),
    );
  }

  static Padding homeGrid(AsyncSnapshot<List<Category>> snapshot,
      Function gridClicked, BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1280, allowFontScaling: false);
    var size = ScreenUtil();
    return Padding(
      padding: EdgeInsets.only(
          left: size.setWidth(10),
          right: size.setWidth(10),
          bottom: size.setWidth(10),
          top: size.setWidth(10)),
      child: GridView.builder(
        //padding: EdgeInsets.all(size.setWidth(10)),
        shrinkWrap: true,
        itemCount: snapshot.data.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            child: Cell(snapshot.data[index]),
            onTap: () {
              _accountid = snapshot.data[index].accountid;
              //print('account id $_accountid');
              showDialog(
                  context: context,
                  builder: (_) => Padding(
                        padding: EdgeInsets.fromLTRB(
                            size.setWidth(60),
                            size.setWidth(360),
                            size.setWidth(60),
                            size.setWidth(360)),
                        child: ShowDistroPercentage(
                            accountid, snapshot.data[index].accountname,
                            snapshot.data[index].mainaccount
                            ),
                      ));

              print(snapshot.data[index].accountname);
              gridClicked(context, snapshot.data[index]);
            },
          );
        },
      ),
    );
  }

// distroPercentange() {
//     ScreenUtil.init(context, width: 720, height: 1280, allowFontScaling: false);
//     var size = ScreenUtil();
//     GlobalKey<FormState> _formkey = GlobalKey();
//     addDistroRate() async {}
//     showDialog(
//         context: context,
//         child:
//         );
//   }
  static FlatButton retryButton(Function fetch) {
    return FlatButton(
      child: Text(
        MESSAGES.INTERNET_ERROR_RETRY,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.normal),
      ),
      onPressed: () => fetch(),
    );
  }
}

