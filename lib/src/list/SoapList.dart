import 'package:app_gestion_savon/src/home/Authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../qr/QrGenerator.dart';

class SoapList extends StatelessWidget{
  const SoapList({Key? key, required this.txt}) : super(key: key);

  final String txt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SoapInformation(txt: txt,),
    );
  }
}

class SoapInformation extends StatefulWidget {
  const SoapInformation({Key? key, required this.txt}) : super(key: key);

  final String txt;

  @override
  _SoapInformationState createState() => _SoapInformationState();
}

class _SoapInformationState extends State<SoapInformation> {
  final Stream<QuerySnapshot> _soapsStream = FirebaseFirestore.instance.collection('soaps').snapshots();
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.txt);
  }

  @override
  Widget build(BuildContext context) {
    return Column (
        children: [
          TextField( // case ou t'ecris
            controller: _textController,
            onChanged: (text) {
              setState(() { });
            },
          ),
          Expanded(
            child : StreamBuilder<QuerySnapshot>(
              stream: _soapsStream,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading");
                }
                if(snapshot.hasData){
                  return ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                      String number = data['number'].toString();
                      String date = data['date'].toDate().toString();

                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.center, // pour avoir les "box" centres
                          children: [
                            (data['reference'].contains(_textController.text)
                                || data['name'].contains(_textController.text)
                                || number.contains(_textController.text)
                                || date.contains(_textController.text)
                            ) ?
                            (
                                Row(
                                    children: [
                                      singleSoap(data['name'],data['reference'],number, date, document.id),
                                      buttons(document.id, context, data['reference'])
                                    ]
                                )
                            ) : Container(),
                          ], // un bouton pour faire qqch
                        ),
                      );
                    }).toList(),
                  );
                }
                else {
                  return const Text("No data");
                }
              },
            ),
          ),

        ]
    );
  }
}

Widget singleSoap(String name, String ref, String qte, String date, String docRef){
  return Container(
      height: 125, // hauteur de la box
      width : 250, // largeur de la box
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), //bord arrondis
          gradient: const LinearGradient( //dégradé de couleur
              colors:
              [
                Color(0xFFFF0000),
                Color(0x9CFF0000), // au jaune
                Color(0xFF720000), //jusqu'au vert
              ]
          )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(name, style: const TextStyle(color: Color(0xFF000000))),
          //ici je dois ajouter les trucs de ma bdd
          Text(ref, style: const TextStyle(color: Color(0xFFC2C2C2))),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Authentication.lvl != 0 ? increaseNumber(docRef, 1) : Container(),
                Text(qte, style: const TextStyle(color: Color(0xFFC2C2C2))),
                Authentication.lvl != 0 ? increaseNumber(docRef,-1) : Container(),
              ]
          ),
          Text(date, style: const TextStyle(color: Color(0xFFC2C2C2)))
        ],
      )
  );
}

Widget deleteButton(String docRef){
  return IconButton(
    icon: const Icon(Icons.delete),
    onPressed: () {
      removeSoap(docRef);
    },
  );
}

Widget increaseNumber(String docRef, int increase){
  Icon sign = const Icon(Icons.add);
  String op = '+1 Savon de référence : ';
  if(increase < 0){
    sign = const Icon(Icons.remove);
    op = '-1 Savon de référence : ';
  }
  return IconButton(
    icon: sign,
    onPressed: () {
      CollectionReference soaps = FirebaseFirestore.instance.collection('soaps');
      soaps
          .doc(docRef)
          .update({'number': FieldValue.increment(increase)})
          .then((value) => {
        print("Soap Deleted"),
        addOp(DateTime.now(), op + docRef)
      })
          .catchError((error) => print("Failed to delete soap: $error"));
    },
  );
}

void addOp(DateTime date, String operation) {
  CollectionReference operations = FirebaseFirestore.instance.collection('operations');
  operations
      .add({
    'date': date, // John Doe
    'operation': operation, // Stokes and Sons
  })
      .then((value) => print("Operation Added"))
      .catchError((error) => print("Failed to add operation: $error"));
}

void removeSoap(String docRef){
  CollectionReference soaps = FirebaseFirestore.instance.collection('soaps');
  soaps
      .doc(docRef)
      .delete()
      .then((value) => {
    print("Soap Deleted"),
    addOp(DateTime.now(), 'Suppression Savon de référence ' + docRef)
  })
      .catchError((error) => print("Failed to delete soap: $error"));
}

Widget getQrButton(BuildContext context, String reference){
  return IconButton(
    icon: const Icon(Icons.qr_code_2),
    onPressed: () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => GenerateQr(value: reference),));
    },
  );
}

Widget buttons(String docRef, BuildContext context, String reference){
  return Column(
    children: [
      Authentication.lvl != 0 ? deleteButton(docRef) : Container(),
      getQrButton(context, reference),
    ],
  );
}