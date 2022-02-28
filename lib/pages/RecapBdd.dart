import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecapBdd extends StatefulWidget {
  const RecapBdd({Key? key}) : super(key: key);

  @override
  _RecapBddState createState() => _RecapBddState();
}

class _RecapBddState extends State<RecapBdd> {
  final Stream<QuerySnapshot> _soapsStream = FirebaseFirestore.instance
      .collection('operations')
      .orderBy('date', descending: true)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
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
                  //return Text(document.id /*+ ' : ' + data['operation']*/);
                  return ListTile(
                        title: Row(
                    mainAxisAlignment: MainAxisAlignment.center, // pour avoir les "box" centres
                    children: [
                      singleOpe(data['operation'],data['date'].toDate().toString()), // mon savon
                        ]
                        ),
                  );
                }).toList(),
              ); // le fait de swiper
            }
            else {
              return const Text("No data");
            }
          },
        ),
    );
  }





  Widget singleOpe(String operation, String dateOpe){
    return Container(
        height: 180, // hauteur de la box
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
            Text(operation, style: const TextStyle(color: Color(0xFF000000))),
            //ici je dois ajouter les trucs de ma bdd
            Text(dateOpe, style: const TextStyle(color: Color(0xFFC2C2C2))),
          ],
        )
    );
  }
}