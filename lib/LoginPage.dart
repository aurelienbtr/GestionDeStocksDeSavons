import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testflutter1/RecapitulatifListeSavon.dart';

class loginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

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
        title: Text('CONNEXION'),
        centerTitle: true,

      ),

      body :SingleChildScrollView(
    child: Column(
      children: [
        imageSavon,
        LoginForm(),
        connexion,
      ],
      ),

    ),
    );
  }
}


class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  var _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal:30,),
      child : Column(
      children: [

        //ICI C'EST L'IDENTIFIANT
        const TextField(
          decoration: InputDecoration(
            labelStyle: TextStyle(
              color: Colors.grey,
            ),
            labelText: 'Identifiant',
          ),
        ),


        //ICI C4EST LE MDP
        TextField(
          obscureText: _obscureText,
        decoration: InputDecoration(
          labelStyle: const TextStyle(
            color: Colors.grey,
          ),
          labelText: 'Mot de passe',
            suffixIcon: IconButton(
            icon: const Icon(
              Icons.visibility,
              color: Colors.black,
        ), onPressed: () { // quand on clique sur l'icone
              setState(() { // pour mettre a jout
                _obscureText = !_obscureText;
              });
            },
        ),
        ),
      )
    ],
    ),
    );
  }
}

Widget connexion = Container(
  width: 200,
  padding: EdgeInsets.all(10),
  margin: EdgeInsets.all(10),
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      primary: Colors.red[400],
      shape: StadiumBorder(),
    ),
    child: Text('SE CONNECTER'),
    onPressed: (){
    },
  ),
);


Widget imageSavon = Container(
  padding: EdgeInsets.all(10),
  margin: EdgeInsets.all(10),
  child: Image.asset('assets/images/savon.jpeg'),
);