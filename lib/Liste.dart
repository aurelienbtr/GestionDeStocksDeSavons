import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}



class _TestPageState extends State<TestPage> {
  TextEditingController _textController = TextEditingController(); // page de recherche

  List<String> initialList = ["Chat", "Chien", "Rat", "Cheval", "Ours"];
  List<String> filteredList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold( // API qui permet d'organiser la page
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
                    child: Text('Aucune donnée'), //on affiche ca
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
  }
}

