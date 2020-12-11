import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uaaccesos/classes/login_state.dart';
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

  _ScanCodeState(CodeController controller) {
    _controller = controller;
    _controller.method = scanner;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  Icons.qr_code_rounded,
                  color: Colors.white,
                  size: 30,
                ),
                Text('Scanner',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    )),
              ],
            ),
            SizedBox(height: 15.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset('assets/images/demo.png'),
            ),
            SizedBox(height: 15.0),
            Text(
              'Para escanear un código QR, selecciona el botón flotante para abrir la cámara.\n\nAlinea perfectamente la zona marcada con la cámara, apuntando al código de manera que este quede centrado, espera un tiempo para que el escáner pueda leer de forma correcta el contenido.',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 17),
            )
          ],
        ),
      ),
    );
  }

  void scanner() async {
    try {
      String codeScanner = await BarcodeScanner.scan(); //barcode scnner

      if (codeScanner.isNotEmpty) {
        final https = await _checkToken.call({"token": codeScanner, "door": Provider.of<LoginState>(context, listen: false).userProp('door')});
        final payload = https.data;

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 6),
          content: Text(
            payload['msg'],
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: payload['ok'] ? Colors.green[600] : Colors.red[900],
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 8),
        content: Text('Ocurrió un error. Intenta de nuevo'),
      ));
    }
  }
}
