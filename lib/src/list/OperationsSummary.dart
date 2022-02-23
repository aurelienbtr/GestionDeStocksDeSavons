import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OperationsSummary extends StatefulWidget {
  const OperationsSummary({Key? key}) : super(key: key);

  @override
  _OperationsSummaryState createState() => _OperationsSummaryState();
}

class _OperationsSummaryState extends State<OperationsSummary> {
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
                    title: Text(data['operation'].toString()),
                    subtitle: Text(data['date'].toDate().toString())
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
}