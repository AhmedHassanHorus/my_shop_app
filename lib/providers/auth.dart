import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:my_shop_app/models/httpException.dart';
import 'dart:convert';

class Auth extends ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get userId {
    return _userId;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate != DateTime.now() &&
        _token != null) {
      return _token;
    }
  }

  Future _authentication(
      {required String password,
      required String email,
      required String whatToDo}) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$whatToDo?key=AIzaSyCPGD-9aud0N7zDKeH0IkveP85S9EyNlKA';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final decodedResponse = json.decode(response.body);
      if (decodedResponse['error'] != null) {
        print(decodedResponse['error']['message']);
        throw HttpException(decodedResponse['error']['message']);
      }
      _token = decodedResponse['idToken'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            decodedResponse['expiresIn'],
          ),
        ),
      );
      _userId = decodedResponse['localId'];
      _autoLogOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String()
      });
      prefs.setString('userData', userData);
      print(json.decode(prefs.getString('userData') as String));
    } catch (error) {
      throw error;
    }
  }

  Future authSingUp({required String password, required String email}) async {
    await _authentication(password: password, email: email, whatToDo: 'signUp');
  }

  Future authSingIn({required String password, required String email}) async {
    await _authentication(
        password: password, email: email, whatToDo: 'signInWithPassword');
  }

  Future tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      print('error 1');
      return false;
    }
    final userData = json.decode(prefs.getString('userData') as String);
    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      print('error 2');
      return false;
    }
    _token = userData['token'];
    _userId = userData['userId'];
    _expiryDate = expiryDate;
    print('2$userData');
    notifyListeners();
    _autoLogOut();
    return true;
  }

  Future logOut() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogOut() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    var _time = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: _time), logOut);
  }
}
