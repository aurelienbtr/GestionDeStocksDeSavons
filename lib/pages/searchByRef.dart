
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../SearchService.dart';
import 'RecapitulatifListSavonHorizontale.dart';

class searchByRef extends StatefulWidget {
  @override
  _searchByRefState createState() => _searchByRefState();
}

class _searchByRefState extends State<searchByRef> {


  TextEditingController _textController = TextEditingController();
  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [12];
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
        else print("la reference ne contient pas la value");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget> [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (val){
                initiateSearch(val);
              },
            ),
          ),
          SizedBox(height: 10.0),
          GridView.count(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              primary: false,
              shrinkWrap: true,
              children: tempSearchStore.map((element) {
                return buildResultCard(element);
              }).toList())
        ],
      ),
    );
  }
}

Widget buildResultCard(data) {
  return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 2.0,
      child: Container(
          child: Center(
              child: Text(data['reference'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              )
          )
      )
  );
}