import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:images_picker/images_picker.dart';
import 'package:scan/scan.dart';

import '../../widgets/qrscan.dart';


class QrScan extends StatefulWidget {
  const QrScan({Key? key}) : super(key: key);

  @override
  State<QrScan> createState() => _QrScan();
}

class _QrScan extends State<QrScan> {
  String _platformVersion = 'Unknown';

  String qrcode = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await Scan.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          children: [
            Text('Running on: $_platformVersion\n'),
            Wrap(
              children: [
                ElevatedButton(
                  child: const Text("parse from image"),
                  onPressed: () async {
                    List<Media>? res = await ImagesPicker.pick();
                    if (res != null) {
                      String? str = await Scan.parse(res[0].path);
                      if (str != null) {
                        setState(() {
                          qrcode = str;
                        });
                      }
                    }
                  },
                ),
                ElevatedButton(
                  child: const Text('go scan page'),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) {
                          return ScanPage();
                        }));
                  },
                ),
              ],
            ),
            Text('scan result is $qrcode'),
          ],
        )
    );
  }
}