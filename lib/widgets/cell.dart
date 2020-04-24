
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:random_color/random_color.dart';
import 'package:walletmanager/apis/getcategories.dart';

 RandomColor _randomColor = RandomColor();



class Cell extends StatelessWidget {
  const Cell(this.catModel);
  @required
  final Category catModel;
  
  

  
 
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1280, allowFontScaling: false);
    var size = ScreenUtil();
    Color _color = _randomColor.randomColor(
   colorBrightness: ColorBrightness.dark
);
   
    return Container(
      decoration: BoxDecoration(
    border: Border.all(color: Colors.red[600])
  ),
      margin: EdgeInsets.all(size.setWidth(5)),
      padding:EdgeInsets.all(size.setWidth(5)), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Icon(Icons.account_balance_wallet,
          color: _color,
          size: size.setWidth(90),
          ),
          Expanded(
                      child: Padding(
              padding: EdgeInsets.all(size.setWidth(5)),
              child: Text(
                catModel.accountname,              
                style: TextStyle(
                  fontSize: size.setSp(24),
                  fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}