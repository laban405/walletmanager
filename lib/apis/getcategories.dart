
import 'dart:convert';

import 'package:walletmanager/apis/httprequestsapis.dart';

class Category{
  String accountcode;
  String accountname;
  String iconname;
  String mainaccount;
  String accountid;
  String distributionrate;
  String accountbalace;

  Category(
    {
      this.accountcode,
      this.accountname,
      this.iconname,
      this.mainaccount,
      this.accountid,
      this.distributionrate,
      this.accountbalace
    }

  );

  factory Category.fromJson(Map<String, dynamic> json) {
    return new Category(
      accountcode: json['account_code'].toString(),
      accountname: json['account_name'] as String,
      iconname: json['icon_name'] as String,
      mainaccount: json['main_account'] as String,
      accountid: json['account_id'].toString(),
     distributionrate: json['distribution_rate'].toString(),
     accountbalace: json['account_balance'].toString()
    );
  }
}


// Future<List<Category>> fetchCategories()async{
//   var res=await getData('account');
//   print('get categories response ${res.body}');

//   return compute(parseData, res.body);
// }

// List<Category> parseData(String responseBody) {
//   final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

//   List<Category> list =
//       parsed.map<Category>((json) => new Category.fromJson(json)).toList();
//   return list;
// }

 Future<List<Category>> fetchCategories(String mainaccounttype) async {
    var response = await getData('account?mainAccount=$mainaccounttype');
    //print('get categories response ${response.body}');

    try {
      if (response.statusCode == 200) {
        List<Category> list = parseCategoriesForHome(response.body);
        return list;
      } else {
        throw Exception('Error fetching data');
      }
    } catch (e) {
      throw Exception('Error fetching data $e');
    }
  }
 
   List<Category> parseCategoriesForHome(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Category>((json) => Category.fromJson(json)).toList();
  }