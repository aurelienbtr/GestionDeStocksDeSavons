
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'RecapitulatifListeSavon.dart';
import 'naviguation_drawer.dart';



class ajoutSavon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: NavigationDrawerWidget(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              titredelapageAjout,
              formulaireAjout,
              //la c'est mon widget : ajouter un savon
            ],
          ),
        ),
      ),
    );
  }
}

Widget formulaireAjout = Container(
    padding: const EdgeInsets.all(10),
    margin: const EdgeInsets.all(10),
    child: Column(
      children: [
        saisirNom,
        saisirRef,
        saisirQte,
        date,
        sauvegarder,
      ],
    ));

Widget saisirNom = Container(
  padding: EdgeInsets.all(10),
  margin: EdgeInsets.all(10),
  child: Column(
    children: [
      TextFormField(
        decoration: const InputDecoration(
            labelText: 'Nom du savon',
            hintText: 'Entrer du texte',
            border: OutlineInputBorder()),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Veuillez saisir un texte';
          }
          return null;
        },
      ),
    ],
  ),
);

Widget saisirRef = Container(
  padding: EdgeInsets.all(10),
  margin: EdgeInsets.all(10),
  child: Column(
    children: [
      TextFormField(
        decoration: const InputDecoration(
            labelText: 'Reference du savon',
            hintText: 'Entrer une reference',
            border: OutlineInputBorder()),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Veuillez saisir une reference';
          }
          return null;
        },
      ),
    ],
  ),
);

Widget saisirQte = Container(
  padding: const EdgeInsets.all(10),
  margin: const EdgeInsets.all(10),
  child: Column(
    children: [
      TextFormField(
          decoration: const InputDecoration(
              labelText: "Entrer une quantite de savon",
              hintText: 'Entrer une quantite',
              border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ]
        // Only numbers can be entered
      )
    ],
  ),
);


Widget sauvegarder = Container(
    child: IconButton(
      icon: Icon(Icons.save),
      onPressed: () {
        MaterialPageRoute(builder: (context) => maListeDeSavons());
      },
    )
);

Widget date = Container(
  padding: const EdgeInsets.all(10),
  margin: const EdgeInsets.all(10),
  child: Column(
    children: [
      TextFormField(
          decoration: const InputDecoration(
              labelText: "Entrer une date",
              hintText: 'Entrer une date',
              border: OutlineInputBorder()),
          keyboardType: TextInputType.datetime,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ]
        // Only numbers can be entered
      )
    ],
  ),
);


Widget titredelapageAjout = AppBar(
  title: Text('Ajouter un savon'),
  centerTitle: true,
  backgroundColor: Colors.red,
);

