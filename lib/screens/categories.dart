
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:walletmanager/apis/getcategories.dart';
import 'package:walletmanager/screens/addcategory.dart';
import 'package:walletmanager/screens/individualtransaction.dart';
import 'package:walletmanager/widgets/cell.dart';
import 'package:walletmanager/widgets/commonwidgets.dart';

String accountid;
String acctname;
int accountcategory=0;

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isHomeDataLoading;

  @override
  void initState() {
    super.initState();
    isHomeDataLoading = false;
  }

  Padding homeGridGood(AsyncSnapshot<List<Category>> snapshot,
      Function gridClicked, BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1280, allowFontScaling: false);
    var size = ScreenUtil();

    _showAccDialog(String id) {}
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
              setState(() {
                accountid = snapshot.data[index].accountid.toString();
                //print('account id $accountid');
              });

              //print('account id $accountid');

              Navigator.push(
                  context,
                  PageTransition(
                      child: ShowDistroPercentage(
                          accountid, snapshot.data[index].accountname,
                          snapshot.data[index].mainaccount
                          ),
                      type: PageTransitionType.fadeIn));

              print(snapshot.data[index].accountname);
              gridClicked(context, snapshot.data[index]);
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1280, allowFontScaling: false);
    var size = ScreenUtil();
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.red[600], //change your color here
            ),
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text(
              'Accounts',
              style: TextStyle(fontSize: size.setSp(32), color: Colors.black87),
            ),
            actions: <Widget>[
              IconButton(
                  color: Colors.red[600],
                  splashColor: Colors.red[600],
                  icon: Icon(
                    Icons.add,
                    color: Colors.black87,
                    size: size.setWidth(60),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: AddCategory(),
                            type: PageTransitionType.slideParallaxDown));
                  }),
            ],
            bottom: TabBar(
             // isScrollable: false,
              indicatorColor: Colors.red[600],
              indicatorWeight: 2,
              onTap: (index){
                //print('index is $index');
                setState(() {
                  accountcategory=index;
                });
              },
              tabs: <Widget>[
                Tab(
                  child: Text(
                    'Income',
                    style: TextStyle(
                        color: Colors.black87, fontSize: size.setSp(28)),
                  ),
                ),
                Tab(
                  child: Text(
                    'Expense',
                    style: TextStyle(
                        color: Colors.black87, fontSize: size.setSp(28)),
                  ),
                ),
              ],
            ),
          ),
          body: Builder(
            builder: (context) => TabBarView(
              children: <Widget>[
                Container(
                  child: FutureBuilder<List<Category>>(
                    future: fetchCategories('Income'),
                    builder: (context, snapshot) {
                      return snapshot.connectionState == ConnectionState.done
                          ? snapshot.hasData
                              ? homeGridGood(snapshot, gridClicked, context)
                              : ComComp.retryButton(fetch)
                          : ComComp.circularProgress();
                    },
                  ),
                ),
                Container(
                  child: FutureBuilder<List<Category>>(
                    future: fetchCategories('Expense'),
                    builder: (context, snapshot) {
                      return snapshot.connectionState == ConnectionState.done
                          ? snapshot.hasData
                              ? homeGridGood(snapshot, gridClicked, context)
                              : ComComp.retryButton(fetch)
                          : ComComp.circularProgress();
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  setLoading(bool loading) {
    setState(() {
      isHomeDataLoading = loading;
    });
  }

  fetch() {
    setLoading(true);
  }
}

gridClicked(BuildContext context, Category catModel) {
  // Grid Click
}
