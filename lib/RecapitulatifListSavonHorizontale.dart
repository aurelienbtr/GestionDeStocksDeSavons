import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class maListeDeSavonsHorizontale extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView( // le fait de swiper
          child: Column(
            children: [
              titredelapage,
              alignement,

            ],
          ),
        ),
      ),
    );
  }
}

Widget titredelapage = AppBar(
  title: Text('Récapitulatif'),
  centerTitle: true,
  backgroundColor: Colors.red,
);


Widget savonUnique = Container(
    height: 75, // hauteur de la box
    width : 350, // largeur de la box
    padding: EdgeInsets.all(10),
    margin: EdgeInsets.all(10),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), //bord arrondis
        gradient: const LinearGradient( //dégradé de couleur
            colors:
            [
              Colors.blue, // du bleu
              Colors.yellow, // au jaune
              Colors.green, //jusqu'au vert
            ]
        )

    ),
    child: Column(
      children: [
        Text("nomduSavon", style: TextStyle(color: Colors.black)),
        //ici je dois ajouter les trucs de ma bdd
        Text("refDuSavon", style: TextStyle(color: Colors.grey)),
        Text("quantite", style: TextStyle(color: Colors.grey))
      ],
    )
);

Widget boutonSupprimer = Container(
    child : IconButton(
      icon: Icon(Icons.delete),
      onPressed: () {
        MaterialPageRoute(builder: (context) => maListeDeSavonsHorizontale());
      },
    )
);


Widget boutonModifier = Container(
    child : IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        MaterialPageRoute(builder: (context) => maListeDeSavonsHorizontale());
      },
    )
);


Widget mesBoutons = Container(
  child: Column(
    children: [
      boutonModifier,
      boutonSupprimer
    ],
  ),
);

Widget alignement = Container(
  child : Column(
    children:[
      Row(
      mainAxisAlignment: MainAxisAlignment.center, // pour avoir les "box" centres
      children: [savonUnique, // mon savon
        mesBoutons], // un bouton pour faire qqch
       ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center, // pour avoir les "box" centres
        children: [savonUnique, // mon savon
          mesBoutons], // un bouton pour faire qqch
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center, // pour avoir les "box" centres
        children: [savonUnique, // mon savon
          mesBoutons], // un bouton pour faire qqch
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center, // pour avoir les "box" centres
        children: [savonUnique, // mon savon
          mesBoutons], // un bouton pour faire qqch
      ),
     ],
  )
);