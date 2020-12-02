import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:uaaccesos/pages/qrcode.dart';

class ScanCode extends StatefulWidget {
  ScanCode({this.controller});

  final CodeController controller;

  @override
  _ScanCodeState createState() => new _ScanCodeState(controller);
}

class _ScanCodeState extends State<ScanCode> {
  HttpsCallable _checkToken = FirebaseFunctions.instance.httpsCallable('validateToken');

  CodeController _controller;
  String _scanned = '';

  _ScanCodeState(CodeController controller) {
    _controller = controller;
    _controller.method = scanner;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text('Scanner value: $_scanned')],
    );
  }

  void scanner() async {
    try {
      String codeScanner = await BarcodeScanner.scan(); //barcode scnner
      print(codeScanner.isNotEmpty);
      if (codeScanner.isNotEmpty) {
        final https = await _checkToken.call({"token": codeScanner, "door": "Norte"}); // TODO: Send admin door
        final payload = https.data;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 6),
          content: Text(payload['msg']),
          backgroundColor: payload['ok'] ? Colors.green[600] : Colors.red[900],
        ));

        setState(() {
          _scanned = codeScanner;
        });
      }
    } catch (e) {}
  }
}
