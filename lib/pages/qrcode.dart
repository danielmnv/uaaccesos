import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uaaccesos/classes/login_state.dart';
import 'package:uaaccesos/pages/generate.dart';
import 'package:uaaccesos/pages/scan.dart';

class CodeController {
  void Function() method;
}

class QrCodePage extends StatefulWidget {
  static Route<dynamic> route() => MaterialPageRoute(builder: (context) => QrCodePage());

  QrCodePage({Key key, this.controller}) : super(key: key);

  final CodeController controller;

  @override
  _QrCodePageState createState() => _QrCodePageState();
}

class _QrCodePageState extends State<QrCodePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(left: 30.0, right: 30.0),
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Provider.of<LoginState>(context).userProp('admin')
            ? ScanCode(controller: widget.controller)
            : GenerateCode(controller: widget.controller),
      ),
    );
  }
}
