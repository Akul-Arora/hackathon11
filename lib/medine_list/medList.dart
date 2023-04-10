import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trijalsrimal/Components/firebase.dart';
import 'package:trijalsrimal/medine_list/returnList.dart';
import 'package:trijalsrimal/search.dart';
import '../Components/menu.dart';

class MedicineListingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<DocumentSnapshot?>.value(
      value: DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .medicine_list,
      initialData: null,
      child: Scaffold(
        drawer: const NavBar(),
        appBar: AppBar(
          title: Text('Medications'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              color: Colors.white,
              onPressed: () {Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Search() ));},
            )
          ],
        ),
        body: List_return(),
      ),
    );
  }
}
