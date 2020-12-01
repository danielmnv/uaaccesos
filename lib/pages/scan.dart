import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:uaaccesos/pages/qrcode.dart';

class ScanCode extends StatefulWidget {
  ScanCode({this.controller});

  final CodeController controller;

  @override
  _ScanCodeState createState() => new _ScanCodeState(controller);
}

class _ScanCodeState extends State<ScanCode> {
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
    String codeSanner = await BarcodeScanner.scan(); //barcode scnner
    setState(() {
      _scanned = codeSanner;
    });
  }
}
