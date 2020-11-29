import 'package:flutter/material.dart';

class RecordPage extends StatelessWidget {
  static Route<dynamic> route() => MaterialPageRoute(builder: (context) => RecordPage());

  @override
  Widget build(BuildContext context) {
    return Text("Hello, Record Zone!");
  }
}
