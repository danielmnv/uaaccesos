import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fAuth;
import 'package:shared_preferences/shared_preferences.dart';

class LoginState with ChangeNotifier {
  final fAuth.FirebaseAuth _auth = fAuth.FirebaseAuth.instance;

  fAuth.User _user;
  SharedPreferences _prefs;
  bool _loggedIn = false;
  bool _loading = true;

  fAuth.User currentUser() => _user;
  bool isLoggedIn() => _loggedIn;
  bool isLoading() => _loading;

  String _snackText;

  LoginState() {
    bindingState();
  }

  Widget _buildSnack() {
    return SnackBar(
      content: Text(_snackText),
      duration: Duration(seconds: 4),
    );
  }

  Future<Widget> logIn(String email, String password) async {
    _loading = false;
    notifyListeners();

    _user = await _handleSignIn(email, password);

    _loggedIn = _user != null;
    _loading = false;

    if (_loggedIn) _prefs.setBool('isLoggedIn', true);

    notifyListeners();

    return _buildSnack();
  }

  void logOut() {
    _loggedIn = false;
    _prefs.clear();
    notifyListeners();
  }

  void bindingState() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey('isLoggedIn')) {
      _user = _auth.currentUser;
      _loggedIn = _user != null;
    }

    _loading = false;
    notifyListeners();
  }

  Future<fAuth.User> _handleSignIn(String email, String password) async {
    fAuth.UserCredential auth;

    try {
      auth = await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      _snackText = 'The credentials are invalid.';
    }

    if (auth != null) {
      _snackText = 'Welcome back ' + auth.user.email;
      return auth.user;
    }

    return null;
  }
}
