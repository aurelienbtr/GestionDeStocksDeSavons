import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppBarWidget /*extends StatelessWidget*/{
  AppBar getAppBar(String title, BuildContext context) {
    return AppBar(
      elevation:0,
      backgroundColor: Colors.red,
      leading: IconButton( /// ici c'est le bouton retour en arriere
        icon : const Icon(
          Icons.close,
          color:Colors.black,
          size:30,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      // la c'est l'endroit ou on ajoute du blabla
      title: Text(title),
      centerTitle: true,
    );
  }

  AppBar getAppBar2(String title) {
    return AppBar(
      elevation:0,
      backgroundColor: Colors.red,
      // la c'est l'endroit ou on ajoute du blabla
      title: Text(title),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Se déconnecter',
          onPressed: () {
            signOut();
          },
        ),
      ],
    );
  }

  AppBar getAppBar3(String title) {
    return AppBar(
      elevation:0,
      backgroundColor: Colors.red,
      // la c'est l'endroit ou on ajoute du blabla
      title: Text(title),
      centerTitle: true,
    );
  }

  Container getFormField(String label, String hint, String empty){
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
                labelText: label,
                hintText: hint,
                border: const OutlineInputBorder()),
            validator: (value) {
              if (value!.isEmpty) {
                return empty;
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
