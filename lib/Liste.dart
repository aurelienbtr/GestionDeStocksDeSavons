import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'SearchService.dart';

class searchByRefTest extends StatefulWidget {
  @override
  _searchByRefTestState createState() => _searchByRefTestState();
}


class _searchByRefTestState extends State<searchByRefTest> {
  TextEditingController _textController = TextEditingController(); // page de recherche
  var queryResultSet = [];
  var tempSearchStore = [];


  Stream<QuerySnapshot> _soapsStream= FirebaseFirestore.instance
      .collection('soaps')
      .snapshots();

  late String searchKey;

  TextEditingController addController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField( // case ou t'ecris
            controller: addController,

            onChanged: (text) {
              setState(() {
                text = text.toLowerCase();
                searchKey = text;
                _soapsStream = FirebaseFirestore
                    .instance
                    .collection('soaps')
                    .where('reference', isEqualTo: searchKey)
                    .snapshots();
                },
              );
            },
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
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
                      return ListTile(
                          title: Text(data['reference']),
                          subtitle: Text(data['name'])
                      );
                    }).toList(),
                  ); // le fait de swiper
                }
                else {
                  return const Text("No data");
                }
              },
            ),
          ),
        ],
      ),
    );

    /*return Scaffold( // API qui permet d'organiser la page
        appBar: AppBar(title: Text('Test search')), //titre de la page
        body: Column(
          children: [
            TextField( // case ou t'ecris
              controller: _textController,
              onChanged: (text) {
                text = text.toLowerCase();
                setState(() { // on verifie si les lettres sont dans un mot de la liste
                  filteredList = initialList
                      .where((element) => element.toLowerCase().contains(text))
                      .toList();
                });
              },
            ),
            if (filteredList.length == 0 &&
                _textController.text.isEmpty) // si il y a rien
              Expanded(
                  child: ListView.builder(
                      itemCount: initialList.length,
                      itemBuilder: (BuildContext context, index) {
                        return Container(
                          height: 50,
                          child: Text(
                              initialList[index]), // on affiche ma liste initial
                        );
                      }))
            else
              if (filteredList.length == 0 && _textController.text
                  .isNotEmpty) // si les lettres ne sont pas dans la liste alors
                Expanded(
                  child: Container(
                    child: Text("Le QR code scanné n'est pas valide"), //on affiche ca
                  ),
                )
              else // sinon en cas de probleme, si il n'y a pas rien mais pas qqch non plus (mdr) alors :
                Expanded(
                  child: ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (BuildContext context, index) {
                        return Container(
                          height: 50,
                          child: Text(filteredList[index]),
                        );
                      }),
                ),
          ],
        ));

     */
  }
/*
  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
        print("vide");
      });
    }

    if (queryResultSet.length == 0 && value.length != 0) {
      SearchService().searchByReference(value).then((QuerySnapshot document) {
        for (int i = 0; i < document.docs.length; i++) {
          print("ok");
          queryResultSet.add(document.docs[i].data);
        }
      });
    }
    else {
      print(" else");
      tempSearchStore = [];
      for (var element in queryResultSet) {
        print("je suis dans le for");
        if (element['reference'].contains(value)) {
          setState(() {
            tempSearchStore.add(element);
          });
          print("else if");
        }
        else
          print("la reference ne contient pas la value");
      }
    }
  }

 */
}