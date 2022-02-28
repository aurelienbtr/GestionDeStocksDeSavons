import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../home/Authentication.dart';

class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final Stream<QuerySnapshot> _soapsStream = FirebaseFirestore.instance.collection('users').snapshots();
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Authentication.lvl == 2 ? Column (
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
                        String lvl = '';
                        switch(data['lvl']){
                          case 0: lvl = 'Lecture'; break;
                          case 1: lvl = 'Écriture'; break;
                          case 2: lvl = 'Admin'; break;
                        }
                        return ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center, // pour avoir les "box" centres
                            children: [
                              (data['mail'].contains(_textController.text)
                              ) ?
                              (
                                Column(
                                    children: [
                                      Row(
                                          children: [
                                            Text(data['mail']),
                                            const SizedBox(width:10),
                                            Text(lvl),
                                            const SizedBox(width:10),
                                            SetRights(rights: data['lvl'], docRef: document.id,),
                                            //singleSoap(data['name'],data['reference'],number, date, document.id),
                                            //buttons(document.id, context, data['reference'])
                                          ]
                                      ),
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
      )
      :
      const Text('Vous n\'avez pas les droits'),
    );
  }
}

// This is the type used by the popup menu below.
enum Rights { read, write, admin }

class SetRights extends StatefulWidget {
  SetRights({Key? key, required this.rights, required this.docRef}) : super(key: key);

  int rights;
  String docRef;

  @override
  State<SetRights> createState() => _SetRightsState();
}

class _SetRightsState extends State<SetRights> {
  Rights? _selection = Rights.read;

  @override
  Widget build(BuildContext context) {
    // This menu button widget updates a _selection field (of type WhyFarther,
    // not shown here).
    return PopupMenuButton<Rights>(
      onSelected: (Rights result) {
        setState(() {
          _selection = result;
          switch(result){
            case Rights.read: widget.rights = 0; break;
            case Rights.write: widget.rights = 1; break;
            case Rights.admin: widget.rights = 2; break;
          }

          CollectionReference users = FirebaseFirestore.instance.collection('users');
          users
              .doc(widget.docRef)
              .update({'lvl': widget.rights})
              .then((value) => {
            print("Rights Changed"),
          })
              .catchError((error) => print("Failed to change rights: $error"));

        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<Rights>>[
        const PopupMenuItem<Rights>(
          value: Rights.read,
          child: Text('Lecture'),
        ),
        const PopupMenuItem<Rights>(
          value: Rights.write,
          child: Text('Écriture'),
        ),
        const PopupMenuItem<Rights>(
          value: Rights.admin,
          child: Text('Administrateur'),
        ),
      ],
    );
  }
}