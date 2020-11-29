import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uaaccesos/classes/login_state.dart';
import 'package:uaaccesos/pages/home.dart';
import 'package:uaaccesos/pages/login.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FirebaseFirestore.instance.settings = Settings(
    host: Platform.isAndroid ? '10.0.2.2:8080' : 'localhost:8080',
    sslEnabled: false,
    persistenceEnabled: false,
  );

  runApp(UAAccess());
}

class UAAccess extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginState>(
      create: (BuildContext context) => LoginState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.teal),
        routes: {
          '/': (BuildContext context) {
            var state = Provider.of<LoginState>(context);

            if (state.isLoggedIn())
              return HomePage(title: 'UAAccess');
            else
              return LoginPage();
          },
        },
      ),
    );
  }
}
