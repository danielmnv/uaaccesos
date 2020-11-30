import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uaaccesos/classes/login_state.dart';
import 'package:uaaccesos/classes/progress.dart';

class QrCodePage extends StatefulWidget {
  static Route<dynamic> route() => MaterialPageRoute(builder: (context) => QrCodePage());

  QrCodePage({Key key}) : super(key: key);

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
        child: Provider.of<LoginState>(context).userProp('admin') ? Text('im an admin') : GenerateCode(),
      ),
    );
  }
}
