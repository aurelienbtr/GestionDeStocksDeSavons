import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../widgets/appbar.dart';

class QrGenerator extends StatefulWidget {
  const QrGenerator({Key? key}) : super(key: key);

  @override
  _QrGeneratorState createState() => _QrGeneratorState();
}
class _QrGeneratorState extends State<QrGenerator> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImage(
              data: controller.text,
              size: 300,
              embeddedImage: const AssetImage('images/logo.png'),
              embeddedImageStyle: QrEmbeddedImageStyle(
                  size: const Size(80,80)
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Enter URL'),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                  });
                },
                child: const Text('GENERATE QR')),
          ],
        ),
      ),
    );
  }
}

class GenerateQr extends StatelessWidget {
  const GenerateQr({Key? key, required this.value}) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget().getAppBar2('Qr Code'),
      body : SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 200.0, height: 50.0,),
              QrImage(
                data: value,
                size: 300,
                embeddedImageStyle: QrEmbeddedImageStyle(
                    size: const Size(80,80)
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: Text('Qr Code pour la référence: ' + value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}