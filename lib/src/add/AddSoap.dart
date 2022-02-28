import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../list/SoapList.dart';

class AddSoap extends StatelessWidget {
  AddSoap({Key? key}) : super(key: key);

  final nameCtrl = TextEditingController();
  final refCtrl = TextEditingController();
  final numberCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //if(Authentication.lvl != 0){
      return SingleChildScrollView(
        child: Column(
          children: [
            addForm(nameCtrl, refCtrl, numberCtrl),
          ],
        ),
      );
    //}
    //else{
    //  return const Text('Vous ne possédez pas les droits administrateurs');
    //}
  }
}

Widget addForm(TextEditingController nameCtrl,
    TextEditingController refCtrl,
    TextEditingController numberCtrl){
  return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          formField(nameCtrl, 'Nom du savon', 'Entrer du texte', 'Veuillez saisir un texte'),
          formField(refCtrl, 'Reference du savon', 'Entrer une reference', 'Veuillez saisir une reference'),
          numberField(numberCtrl, 'Entrer une quantite de savon', 'Entrer une quantite', 'Veuillez saisir une quantite'),
          Save(nameCtrl : nameCtrl, refCtrl : refCtrl, numberCtrl : numberCtrl),
        ],
      ));
}

Widget formField(TextEditingController ctrl, String labelText, String hintText, String validator){
  return Container(
    padding: const EdgeInsets.all(10),
    margin: const EdgeInsets.all(10),
    child: Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              border: const OutlineInputBorder()),
          validator: (value) {
            if (value!.isEmpty) {
              return validator;
            }
            return null;
          },
          controller: ctrl,
        ),
      ],
    ),
  );
}

Widget numberField(TextEditingController numberCtrl, String labelText, String hintText, String validator){
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
          validator: (value) {
            if (value!.isEmpty) {
              return 'Veuillez saisir une quantite';
            }
            return null;
          },
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
                test = check(widget.nameCtrl.text, widget.refCtrl.text, widget.numberCtrl.text);
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

bool check(String name, String ref, String number){
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