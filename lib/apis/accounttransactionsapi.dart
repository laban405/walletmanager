import 'dart:convert';

import 'package:walletmanager/apis/httprequestsapis.dart';

//String accperiod='0';

class AccTransactionApi {
  String amount;
  String narration;
  String date;
  String entrytype;

  AccTransactionApi(
      {this.amount,
      this.narration,
      this.date,
      this.entrytype
      
      });

  factory AccTransactionApi.fromJson(Map<String, dynamic> json) {
    return new AccTransactionApi(
      amount: json["amount"].toString(),
      narration: json["narration"] as String,
      date: json["trx_date"] as String,
      entrytype: json["entry"] as String,
      
    );
  }
}

Future<List<AccTransactionApi>> fetchAccTransaction(String id,int accperiod) async {
  //print(' id is  $id and period is $accperiod');
  var response = await getData('account-transactions/$id?period=$accperiod');
  var result = json.decode(response.body);
  var decode = json.encode(result["transactions"]);
  // print('get =>>>>>>>>> account trasactions response ${response.body}');
  // print('decode>>>>$decode');

  try {
    if (response.statusCode == 200) {
      List<AccTransactionApi> list = parseAccTransactions(decode);
      // print('list done');
      //  print('list is>>>>${list.length}');
      return list;
    } else {
      throw Exception('Error fetching data');
    }
  } catch (e) {
    throw Exception('Error fetching data $e');
  }
  
}

List<AccTransactionApi> parseAccTransactions(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  //print('parse done');
  return parsed
      .map<AccTransactionApi>((json) => AccTransactionApi.fromJson(json))
      .toList();
}


class AccTransactionData{
  String balance;
  String totaldebit;
  String totalcredit;
  String periodicbalance;

  AccTransactionData({
    this.balance,
    this.totaldebit,
    this.totalcredit,
    this.periodicbalance
  });

   
}

AccTransactionData accTransactionData= AccTransactionData();


Future<AccTransactionData> fetchAccBalance(String id, int accperiod)async {
  AccTransactionData accTransactionData= AccTransactionData();
  var res = await getData('account-transactions/$id?period=$accperiod');

  //print('account balance res ${res.body}');
  var decode=json.decode(res.body);
  //String balance=decode['wallet_balance'].toString();
  accTransactionData.balance=decode['account_balance'].toString();
  accTransactionData.totaldebit=decode['total_debit'].toString();
  accTransactionData.totalcredit=decode['total_credit'].toString();
  accTransactionData.periodicbalance=decode['period_balance'].toString();

  return accTransactionData;
}

