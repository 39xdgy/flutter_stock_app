// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.nickName,
    required this.email,
    required this.phoneNumber,
    required this.cookieNumber,
    required this.favStock,
    required this.resultList,
    required this.strategy,
  });

  String id;
  String firstName;
  String lastName;
  String nickName;
  String email;
  String phoneNumber;
  int cookieNumber;
  List<ResultList> resultList;
  List<String> favStock;
  List<String> strategy;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        nickName: json["nick_name"],
        email: json["email"],
        phoneNumber: json["phone_number"],
        cookieNumber: json["cookie_number"],
        resultList: json["result_list"] == null
            ? []
            : List<ResultList>.from(
                json["result_list"]!.map((x) => ResultList.fromJson(x))),
        favStock: json["fav_stock"] == null
            ? []
            : List<String>.from(json["fav_stock"]!.map((x) => x)),
        strategy: json["strategy"] == null
            ? []
            : List<String>.from(json["strategy"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "nick_name": nickName,
        "email": email,
        "phone_number": phoneNumber,
        "cookie_number": cookieNumber,
        "result_list": resultList == null
            ? []
            : List<dynamic>.from(resultList.map((x) => x.toJson())),
        "fav_stock":
            favStock == null ? [] : List<dynamic>.from(favStock.map((x) => x)),
        "strategy":
            strategy == null ? [] : List<dynamic>.from(strategy.map((x) => x)),
      };
}

class ResultList {
  ResultList({
    this.uid,
    this.strategyId,
    this.stocks,
  });

  String? uid;
  String? strategyId;
  List<Stock>? stocks;

  factory ResultList.fromJson(Map<String, dynamic> json) => ResultList(
        uid: json["uid"],
        strategyId: json["strategy_id"],
        stocks: json["stocks"] == null
            ? []
            : List<Stock>.from(json["stocks"]!.map((x) => Stock.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "strategy_id": strategyId,
        "stocks": stocks == null
            ? []
            : List<dynamic>.from(stocks!.map((x) => x.toJson())),
      };
}

class Stock {
  Stock({
    this.stockTicker,
    this.result,
  });

  String? stockTicker;
  double? result;

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
        stockTicker: json["stock_ticker"],
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "stock_ticker": stockTicker,
        "result": result,
      };
}
