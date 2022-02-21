import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'RecapitulatifListSavonHorizontale.dart';

class ajoutSavon extends StatelessWidget {
  final nameCtrl = TextEditingController();
  final refCtrl = TextEditingController();
  final numberCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Column(
            children: [
              formulaireAjout(nameCtrl, refCtrl, numberCtrl),
            ],
          ),
        );
  }
}

Widget formulaireAjout(TextEditingController nameCtrl,
    TextEditingController refCtrl,
    TextEditingController numberCtrl){
  return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          saisirNom(nameCtrl),
          saisirRef(refCtrl),
          saisirQte(numberCtrl),
          Save(nameCtrl : nameCtrl, refCtrl : refCtrl, numberCtrl : numberCtrl),
        ],
      ));
}

Widget saisirNom(TextEditingController nameCtrl){
  return Container(
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
          controller: nameCtrl,
        ),
      ],
    ),
  );
}

Widget saisirRef(TextEditingController refCtrl){
  return Container(
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
          controller: refCtrl,
        ),
      ],
    ),
  );
}

Widget saisirQte(TextEditingController numberCtrl){
  return Container(
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
          ],
          // Only numbers can be entered
          controller: numberCtrl,
        )
      ],
    ),
  );
}

class Save extends StatefulWidget {
  const Save({Key? key, required this.nameCtrl, required this.refCtrl, required this.numberCtrl}) : super(key: key);

  final TextEditingController nameCtrl;
  final TextEditingController refCtrl;
  final TextEditingController numberCtrl;

  @override
  _SaveState createState() => _SaveState();
}

class _SaveState extends State<Save> {
  String fail = '';
  bool test = false;
  @override
  Widget build(BuildContext context) {
      return Column(
          children: [
            Text(
                fail,
                style: const TextStyle(color: Colors.red)
            ),
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                setState((){
                  test = verif(widget.nameCtrl.text, widget.refCtrl.text, widget.numberCtrl.text);
                  if(test){
                    addSoap(widget.nameCtrl.text, widget.refCtrl.text, int.parse(widget.numberCtrl.text));
                    fail = 'Savon ajouter avec succès';
                  }
                  else{
                    fail = 'Tous les champs doivent être remplis.';
                  }
                });
              },
            ),
          ]
      );
    }
  }

bool verif(String name, String ref, String number){
  if(name.isEmpty || ref.isEmpty || number.isEmpty){
    print('Tous les champs doivent être remplis');
    return false;
  }
  else{
      return true;
  }
}

void addSoap(String name, String ref, int number) {
  DateTime now = DateTime.now();
  CollectionReference soaps = FirebaseFirestore.instance.collection('soaps');
  // Call the user's CollectionReference to add a new user
  soaps
      .add({
    'name': name, // John Doe
    'reference': ref, // Stokes and Sons
    'number': number, // 42
    'date': now,
  })
      .then((value) => {
    print("Soap Added"),
    addOp(now, 'Ajout d\'un nouveau savon, référence :\n  - référence : ' + ref + ' : ' + '\n  - nom : ' + name + ' : ' + '\n  - quantité : ' + number.toString() + ' : ')
  })
      .catchError((error) => print("Failed to add soap: $error"));
}