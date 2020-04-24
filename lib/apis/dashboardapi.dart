import 'dart:convert';

import 'package:walletmanager/apis/httprequestsapis.dart';

class DashBoardApi {
  String amount;
  String narration;
  String date;
  String accountid;
  String accounttype;
  String accname;
  String balance;
  String transactionType;

  DashBoardApi(
      {this.amount,
      this.narration,
      this.date,
      this.accountid,
      this.accounttype,
      this.accname,
      this.balance,
      this.transactionType
      });

  factory DashBoardApi.fromJson(Map<String, dynamic> json) {
    return new DashBoardApi(
      amount: json["amount"].toString(),
      narration: json["narration"] as String,
      date: json["date"] as String,
      accountid: json["account_id"].toString(),
      accounttype: json["account_type"].toString(),
      accname: json["account_name"].toString(),
      transactionType: json["transaction_type"].toString()
    );
  }
}

Future<List<DashBoardApi>> fetchCategories2(int period) async {
  var response = await getData('dashboard?period=$period');
  var result = json.decode(response.body);
  var decode = json.encode(result["transactions"]);
  // print('get categories response ${response.body}');

  try {
    if (response.statusCode == 200) {
      List<DashBoardApi> list = parseCategoriesForHome(decode);
      return list;
    } else {
      throw Exception('Error fetching data');
    }
  } catch (e) {
    throw Exception('Error fetching data $e');
  }
}

List<DashBoardApi> parseCategoriesForHome(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<DashBoardApi>((json) => DashBoardApi.fromJson(json))
      .toList();
}


class Balance{
  String balance;
  String totalexpense;
  String totalincome;
  String periodicbalance;

  Balance({
    this.balance,
    this.totalexpense,
    this.totalincome,
    this.periodicbalance
  });

   factory Balance.fromJson(Map<String, dynamic> json) {
    return new Balance(
      balance: json['wallet_balance'].toString(),
      totalexpense: json['total_expense'].toString(),
      totalincome: json['total_income'].toString(),
      periodicbalance: json['period_balance'].toString(),
      
    );
  }
}


Future<Map<String,dynamic>> fetchBalance(String period)async {
  //print('balac');
  Map<String,dynamic> data;
  var res = await getData('dashboard?period=$period');
  var decode=json.decode(res.body);
  //print('decode is>>>>>>>>>>>>>>>>>..$decode');
  data=decode;

  return data;
}

