import 'package:flutter/material.dart';
import 'package:scan/scan.dart';

import '../src/list/SoapList.dart';

class ScanPage extends StatelessWidget {
  ScanPage({Key? key}) : super(key: key);

  final ScanController controller = ScanController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Stack(
          children: [
            ScanView(
              controller: controller,
              scanAreaScale: .7,
              scanLineColor: Colors.green,
              onCapture: (data) {
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return Scaffold(
                      appBar: AppBar(
                        title: const Text('résultats du scan :'),
                      ),
                      body: Center(
                        child: SoapInformation(txt: data),
                      ),
                    );
                  },
                )).then((value) {
                  controller.resume();
                });
              },
            ),
            Positioned(
              bottom: 0,
              child: Row(
                children: [
                  ElevatedButton(
                    child: const Text("Flash"),
                    onPressed: () {
                      controller.toggleTorchMode();
                    },
                  ),
                  ElevatedButton(
                    child: const Text("pause"),
                    onPressed: () {
                      controller.pause();
                    },
                  ),
                  ElevatedButton(
                    child: const Text("reprendre"),
                    onPressed: () {
                      controller.resume();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}