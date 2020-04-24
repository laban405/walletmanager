import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:walletmanager/screens/Home.dart';
import 'package:walletmanager/screens/categories.dart';
import 'package:walletmanager/screens/distributionrate.dart';
import 'package:walletmanager/screens/login.dart';
import 'package:walletmanager/screens/distributionamount.dart';
import 'package:walletmanager/screens/resetpassword/updatepassword.dart';

drawerFunction(BuildContext context) {
  ScreenUtil.init(context, width: 720, height: 1280, allowFontScaling: false);
  var size = ScreenUtil();
  return Drawer(
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          //color: Colors.grey,
          height: ScreenUtil().setHeight(350),
          width: MediaQuery.of(context).size.width,
          child: DrawerHeader(
            child: Padding(
              padding: EdgeInsets.fromLTRB(size.setWidth(0), size.setWidth(30),
                  size.setWidth(0), size.setWidth(0)),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: size.setWidth(70),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                       
                        SizedBox(
                          height: size.setHeight(5),
                        ),
                        Text(
                          'Wallet Manager',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(30),
                            color: Colors.red[600],
                          ),
                        ),
                        SizedBox(
                          height: size.setHeight(1),
                        ),
                        Text(
                          '$username',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(22),
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '$useremail',
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(22),
                            color: Colors.grey[600],
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.category),
          title: Text('Accounts'),
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    child: Categories(), type: PageTransitionType.slideLeft));
          },
        ),
        ListTile(
          leading: Icon(Icons.swap_horizontal_circle),
          title: Text('Income Distribution'),
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    child: DistroAmount(), type: PageTransitionType.slideLeft));
          },
        ),
        ListTile(
          leading: Icon(Icons.share),
          title: Text('Distribution Settings'),
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    child: DistributionRate(),
                    type: PageTransitionType.slideLeft));
          },
        ),
        ListTile(
          leading: Icon(Icons.lock),
          title: Text('Security'),
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    child: UpdatePassword(),
                    type: PageTransitionType.slideLeft));
          },
        ),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Logout'),
          onTap: () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: Login(), type: PageTransitionType.slideLeft));
          },
        ),
      ],
    ),
  );
}
