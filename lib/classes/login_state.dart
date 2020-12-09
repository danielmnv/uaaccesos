import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fAuth;
import 'package:shared_preferences/shared_preferences.dart';

class LoginState with ChangeNotifier {
  final fAuth.FirebaseAuth _auth = fAuth.FirebaseAuth.instance;
  Map<String, dynamic> _data;

  fAuth.User _user;
  SharedPreferences _prefs;
  bool _loggedIn = false;
  bool _loading = true;

  fAuth.User currentUser() => _user;
  Map<String, dynamic> userData() => _data;
  dynamic userProp(String prop) => _data[prop];
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
    _data = await loadUserData();

    if (_loggedIn) {
      _prefs.setBool('isLoggedIn', true);
      _snackText = 'Welcome back ' + _data['name'] + ' ' + _data['ap_pat'];
    }

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

      _data = await loadUserData();
    }

    _loading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> loadUserData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(_user.uid).get();
    if (doc.exists) return doc.data();

    return null;
  }

  Future<fAuth.User> _handleSignIn(String email, String password) async {
    fAuth.UserCredential auth;

    try {
      auth = await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      _snackText = 'The credentials are invalid.';
    }

    return (auth != null) ? auth.user : null;
  }
}
