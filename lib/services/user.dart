import 'package:http/http.dart' as http;
import 'dart:developer';
import 'package:fortune_cookie/end_points/api.dart';
import 'package:fortune_cookie/models/user.dart';
import 'dart:convert';

class UserService {
  Future<User?> getUserById(String id) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.userEndpoint + id);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        User user = User.fromJson(responseData['Payload']);
        return user;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<String?> createUser(String id, String nickName, String email) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.userEndpoint);
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "firebase_id": id,
          "nick_name": nickName,
          "email": email,
        }),
      );
      //print(response.body);
      if (response.statusCode == 200) {
        return "success";
      } else {
        return "error";
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<String?> updateUser(
    String id,
    String firstName,
    String lastName,
    String nickName,
    String email,
    String phone,
    int cookieNumber,
    List<String> resultList,
    List<String> favStock,
    List<String> strategy,
  ) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.userEndpoint + id);
      final body = jsonEncode({
        "first_name": firstName,
        "last_name": lastName,
        "nick_name": nickName,
        "email": email,
        "phone": phone,
        "cookie_number": cookieNumber.toString(),
        "result_list": resultList,
        "fav_stock": favStock,
        "strategy": strategy,
      });
      print(body);
      final response = await http.put(
        headers: {'Content-Type': 'application/json'},
        url,
        body: body,
      );
      //print(response.body);
      if (response.statusCode == 200) {
        return "success";
      } else {
        print(response.body);
        return "error";
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
