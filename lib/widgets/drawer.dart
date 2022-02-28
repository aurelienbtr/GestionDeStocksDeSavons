import 'package:app_gestion_savon/src/list/OperationsSummary.dart';
import 'package:app_gestion_savon/src/qr/QrGenerator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../src/add/AddSoap.dart';
import '../src/home/Authentication.dart';
import '../src/list/UserList.dart';
import '../src/qr/QrScan.dart';
import '../src/list/SoapList.dart';
import 'appbar.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({Key? key}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  Widget? w = const SoapList(txt:'');
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
                        text: 'Liste de Savons',
                        icon: Icons.list_alt,
                        onClicked: () {
                          setState((){
                            w = const SoapList(txt: '');
                            title = 'Liste de Savons';
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                      Authentication.lvl != 0 ?
                      buildMenuItem(
                        text: 'Ajouter',
                        icon: Icons.add,
                        onClicked: () {
                          setState((){
                            w = AddSoap();
                            title = 'Ajouter un Savon';
                          });
                          Navigator.of(context).pop();
                        },
                      )
                      : const SizedBox.shrink(),
                      buildMenuItem(
                        text: 'Scanner',
                        icon: Icons.smartphone,
                        onClicked: () {
                          setState((){
                            w = const QrScan();
                            title = 'Scanner';
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                      buildMenuItem(
                        text: 'Générateur de Qr Code',
                        icon: Icons.qr_code_2,
                        onClicked: () {
                          setState((){
                            w = const QrGenerator();
                            title = 'Générateur de Qr Codes';
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                      buildMenuItem(
                        text: 'Récapitulatif des Opérations',
                        icon: Icons.list,
                        onClicked: () {
                          setState((){
                            w = const OperationsSummary();
                            title = 'Récapitulatif des Opérations';
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
                            w = const OperationsSummary();
                            title = 'Générateur de Qr Codes';
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                      Authentication.lvl == 2 ?
                      buildMenuItem(
                        text: 'Paramètres',
                        icon: Icons.settings,
                        onClicked: () {
                          setState((){
                            w = const UserList();
                            title = 'Paramètres';
                          });
                          Navigator.of(context).pop();
                        },
                      ) : const SizedBox.shrink(),
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
    const hoverColor = Colors.black26;

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