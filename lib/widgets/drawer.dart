import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/AjoutSavon.dart';
import '../pages/RecapBdd.dart';
import '../pages/RecapitulatifListSavonHorizontale.dart';
import '../pages/generator.dart';
import '../pages/scan.dart';
import 'appbar.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  Widget? w = const SoapList();
  String title = 'Liste de Savons';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Material(
        color: const Color.fromRGBO(255, 255, 255, 1),
            child: ListView(
                children: <Widget>[
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.red,
                    ),
                    child: Text(
                      'Gestion de Stock',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      buildMenuItem(
                        text: 'Recapitulatif',
                        icon: Icons.message,
                        onClicked: () {
                          setState((){
                            w = const SoapList();
                            title = 'Liste de Savons';
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                      const SizedBox(height: 8),
                      buildMenuItem(
                        text: 'Ajouter',
                        icon: Icons.add,
                        onClicked: () {
                          setState((){
                            w = ajoutSavon();
                            title = 'Ajouter un Savon';
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                      const SizedBox(height: 8),
                      buildMenuItem(
                        text: 'Scanner',
                        icon: Icons.smartphone,
                        onClicked: () {
                          setState((){
                            w = const QrScan3(title: 'Scanneur',);
                            title = 'Scanneur';
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                      buildMenuItem(
                        text: 'Générateur de Qr Code',
                        icon: Icons.qr_code_2,
                        onClicked: () {
                          setState((){
                            w = const GenerateQRPage();
                            title = 'Générateur de Qr Codes';
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                      const SizedBox(height: 8),
                      const Divider(color: Colors.black),
                      const SizedBox(height: 8),
                      buildMenuItem(
                        text: 'Profil',
                        icon: Icons.account_circle,
                        onClicked: () {
                          setState((){
                            w = const GenerateQRPage();
                            title = 'Générateur de Qr Codes';
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                      const SizedBox(height: 8),
                      buildMenuItem(
                        text: 'Paramètres',
                        icon: Icons.settings,
                        onClicked: () {
                          setState((){
                            w = const RecapBdd();
                            title = 'Récapitulatif';
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                      const SizedBox(height: 8),
                      buildMenuItem(
                        text: 'Se déconnecter',
                        icon: Icons.exit_to_app,
                        onClicked: () {
                          setState((){
                            signOut();
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ]
            )
        ),
        ),
      appBar: AppBarWidget().getAppBar2(title),
      body: w,
      //floatingActionButton: reloadButton(w),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    const color = Colors.black;
    final hoverColor = Colors.black26;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: const TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}