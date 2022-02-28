import 'package:app_gestion_savon/src/list/SoapList.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:images_picker/images_picker.dart';
import 'package:scan/scan.dart';

import '../../widgets/qrscan.dart';
import '../../widgets/widgets.dart';


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
            Text('A partir de : $_platformVersion\n'),
            Wrap(
              children: [
                StyledButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) {
                          return ScanPage();
                        }));
                  },
                  txt: 'scanner avec l\'appareil',
                ),
                StyledButton2(
                  onPressed: () async {
                    List<Media>? res = await ImagesPicker.pick();
                    if (res != null) {
                      String? str = await Scan.parse(res[0].path);
                      if (str != null) {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (BuildContext context) {
                            return Scaffold(
                              appBar: AppBar(
                                title: const Text('résultats du scan :'),
                              ),
                              body: Center(
                                child: SoapInformation(txt: str),
                              ),
                            );
                          },
                        ));
                      }
                    }
                  },
                  txt: 'scanner à partir d\'une image',
                ),
              ],
            ),
            Text('résultats du scan : $qrcode'),
          ],
        )
    );
  }
}