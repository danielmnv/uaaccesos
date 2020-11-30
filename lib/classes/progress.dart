import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateCode extends StatefulWidget {
  @override
  _GenerateCodeState createState() => new _GenerateCodeState();
}

class _GenerateCodeState extends State<GenerateCode> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  HttpsCallable _buildToken = FirebaseFunctions.instance.httpsCallable('createToken');
  String _token;

  @override
  void initState() {
    super.initState();

    _getToken();

    _controller = AnimationController(duration: const Duration(seconds: 15), vsync: this);
    _animation = Tween(begin: 1.0, end: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
          if (_animation.value <= 0.01) {
            _getToken();
          }
        });
      });
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 7),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                Icons.qr_code_rounded,
                color: Colors.indigo,
                size: 30,
              ),
              Text('QR Code', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.indigo)),
            ],
          ),
        ),
        QrImage(data: _token),
        SizedBox(height: 20),
        LinearProgressIndicator(value: _animation.value),
      ],
    );
  }

  Future<void> _getToken() async {
    final https = await _buildToken();
    final payload = https.data;

    if (payload['ok']) {
      _token = payload['jwt'];
    }
  }
}
