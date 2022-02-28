import 'package:app_gestion_savon/pages/searchByRef.dart';
import 'package:flutter/material.dart';
import 'package:scan/scan.dart';

class ScanPage extends StatelessWidget {
  ScanController controller = ScanController();
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
                        title: const Text('scan result'),
                      ),
                      body: Center(
                        child: searchByRef(),
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
                    child: const Text("toggleTorchMode"),
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
                    child: const Text("resume"),
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