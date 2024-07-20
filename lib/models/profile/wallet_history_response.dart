import 'dart:convert';

import '../general/links.dart';
import '../general/meta.dart';

WalletHistoryResponse walletHistoryResponseFromJson(String str) =>
    WalletHistoryResponse.fromJson(json.decode(str));

String walletHistoryResponseToJson(WalletHistoryResponse data) =>
    json.encode(data.toJson());

class WalletHistoryResponse {
  WalletHistoryResponse({
    required this.recharges,
    this.links,
    this.meta,
    required this.success,
    required this.status,
  });

  List<Recharge> recharges;
  Links? links;
  Meta? meta;
  bool success;
  int status;

  factory WalletHistoryResponse.fromJson(Map<String, dynamic> json) =>
      WalletHistoryResponse(
        recharges:
            List<Recharge>.from(json["data"].map((x) => Recharge.fromJson(x))),
        links: Links.fromJson(json["links"]),
        meta: Meta.fromJson(json["meta"]),
        success: json["success"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(recharges.map((x) => x.toJson())),
        "links": links?.toJson(),
        "meta": meta?.toJson(),
        "success": success,
        "status": status,
      };
}

class Recharge {
  Recharge({
    required this.amount,
    required this.paymentMethod,
    required this.approvalString,
    required this.date,
  });

  String amount;
  String paymentMethod;
  String approvalString;
  String date;

  factory Recharge.fromJson(Map<String, dynamic> json) => Recharge(
        amount: json["amount"],
        paymentMethod: json["payment_method"],
        approvalString: json["approval_string"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "payment_method": paymentMethod,
        "approval_string": approvalString,
        "date": date,
      };
}
