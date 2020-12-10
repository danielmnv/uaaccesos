import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uaaccesos/pages/qrcode.dart';

class GenerateCode extends StatefulWidget {
  GenerateCode({this.controller});

  final CodeController controller;

  @override
  _GenerateCodeState createState() => new _GenerateCodeState(controller);
}

class _GenerateCodeState extends State<GenerateCode> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  HttpsCallable _buildToken = FirebaseFunctions.instance.httpsCallable('createToken');
  CodeController _controller;
  String _token = "t2vjd@Nzh#Bo9mT^8S3@";

  _GenerateCodeState(CodeController controller) {
    _controller = controller;
    _controller.method = _getToken;
  }

  @override
  void initState() {
    super.initState();

    _getToken(false);

    _animationController = AnimationController(duration: const Duration(minutes: 1), vsync: this);
    _animation = Tween(begin: 1.0, end: 0.0).animate(_animationController)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
          if (_animation.value <= 0.01) {
            _getToken(false);
          }
        });
      });
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    Icons.qr_code_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                  Text('QR Code',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
            SizedBox(height: 15.0),
            QrImage(
              data: _token,
              backgroundColor: Colors.white,
            ),
            SizedBox(height: 30),
            LinearProgressIndicator(value: _animation.value),
            SizedBox(height: 15.0),
            Text(
              'Presenta este código QR para poder ingresar a las instalaciones.\n\nPuedes generar uno nuevo puslando el boton flotante. Cada código tiene un ciclo de vida de un minuto.',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 17),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _getToken([bool reset = true]) async {
    final https = await _buildToken();
    final payload = https.data;

    if (payload['ok']) {
      _token = payload['jwt'];
    }

    if (reset) {
      _animationController.reset();
      _animationController.repeat();
    }
  }
}
