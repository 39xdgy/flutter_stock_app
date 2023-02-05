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
        body: {
          "id": id,
          "email": email,
        },
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
}
