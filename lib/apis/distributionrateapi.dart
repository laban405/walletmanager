

import 'dart:convert';

import 'httprequestsapis.dart';

class DistributionData{
  String accountID;
  String accountName;
  String distroRateID;
  String distroRate;

  DistributionData(
    {
      this.accountID,
      this.accountName,
      this.distroRateID,
      this.distroRate
    }
  );

  factory DistributionData.fromJson(Map<String, dynamic> json){
    return DistributionData(
      accountID: json['account_id'].toString(),
      accountName: json['account_name'].toString(),
      distroRateID: json['distribution_rate_id'].toString(),
      distroRate: json['distribution_rate'].toString(),

    );
  }
}





var distroratebody;
Future<List<DistributionData>> fetchDistro(String incomeAccounttype) async {
    var response = await getData('distribution-percentage/$incomeAccounttype');
    
    distroratebody=json.decode(response.body);
    try {
      if (response.statusCode == 200) {
        List<DistributionData> list = parseCategoriesForHome(response.body);
        return list;
      } else {
        throw Exception('Error fetching data');
      }
    } catch (e) {
      throw Exception('Error fetching data $e');
    }
  }
 
   List<DistributionData> parseCategoriesForHome(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<DistributionData>((json) => DistributionData.fromJson(json)).toList();
  }