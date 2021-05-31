import 'dart:async';
import 'package:uts/Models/UserSql.dart';
import 'package:uts/DbHelper/DbHelper.dart';

class LoginRequest {
  DbHelper dbHelper = new DbHelper();
 Future<UserSql> getLogin(String username, String password) {
    var result = dbHelper.getLogin(username,password);
    return result;
  }
}