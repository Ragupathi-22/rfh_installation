import 'package:hive_flutter/hive_flutter.dart';

// Box Storage Class to Store User Details
class BoxStorage {
  var box = Hive.box('box_Installer');

  save(key, value) {
    box.put(key, value);
  }

  //Get Details Based on Key
  get(key) {
    return box.get(key);
  }

  //Save User Details
  saveUserDetails(userdetails) {
    box.put('user', userdetails);
  }

  //Get User Details
  getUserDetails() {
    return box.get('user');
  }

  //Delete User Details
  deleteUserDetails() {
    return box.delete('user');
  }

  //Save User Token
  saveUserToken(String token) {
    box.put('userToken', token);
  }

  //Get User Token
  String? getUserToken() {
    return box.get('userToken');
  }

  //Delete User Token
  deleteUserToken() {
    box.delete('userToken');
  }

  //Save User Type
  saveUserType(String userType) {
    box.put('userType', userType);
  }

  //Get User Type
  String? getUserType() {
    return box.get('userType');
  }

  //Delete User Type
  deleteUserType() {
    box.delete('userType');
  }

  //Clear all user data
  clearAllUserData() {
    deleteUserDetails();
    deleteUserToken();
    deleteUserType();
    deleteLoginInfo();
  }

  //save login info
  saveLoginInfo(name, password, rememberMe) {
    box.put('logInfo',
        {'username': name, 'password': password, 'rememberMe': rememberMe});
  }

  //get login info
  getLoginInfo() {
    return box.get('logInfo');
  }

  //Delete login info
  deleteLoginInfo() {
    box.delete('logInfo');
  }
}
