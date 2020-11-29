import 'package:flutter/material.dart';

class QrCodePage extends StatelessWidget {
  static Route<dynamic> route() => MaterialPageRoute(builder: (context) => QrCodePage());

  @override
  Widget build(BuildContext context) {
    return Text("Hello, QR Zone!");
  }
}
