import 'dart:html';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:trijalsrimal/medine_list/medList.dart';


import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/services.dart';
import 'package:trijalsrimal/Components/firebase.dart';

import 'main.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const Search());
}

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('Search Medicine'),
        backgroundColor: HexColor("#4169E1"),
        leading: IconButton(icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {Navigator.push(context,
              MaterialPageRoute(builder: (context) => MedicineListingPage() ));},
        ),
    ),
      body: const FirebaseSearchScreen(),
    );
  }
}

class FirebaseSearchScreen extends StatefulWidget {
  const FirebaseSearchScreen({Key? key}) : super(key: key);

  @override
  State<FirebaseSearchScreen> createState() => _FirebaseSearchScreenState();
}

class _FirebaseSearchScreenState extends State<FirebaseSearchScreen> {
  List searchResult = [];

  /*void searchFromFirebase(String query) async {
    final result = await FirebaseFirestore.instance
        .collection('medicine')
        .where('med_list', )
        .get();

    setState(() {
      searchResult = result.docs.map((e) => e.data()).toList();
    });
  }*/

  Future<void> searchMedList(String prompt) async {
    // Get a reference to the 'medicine' collection and document
    final medicineCollection = FirebaseFirestore.instance.collection('medicine');
    final medicineDocRef = medicineCollection.doc('medicine');

    // Get the 'med_list' map from the document data
    final medicineDocSnapshot = await medicineDocRef.get();
    final medListMap = medicineDocSnapshot.data()?['med_list'] as Map<String, dynamic>?;

    if (medListMap != null) {
      // Filter the key-value pairs of the 'med_list' map where the key contains the prompt
      final matchingItems = medListMap.entries
          .where((entry) => entry.key.contains(prompt))
          .toList();

      // Do something with the matching items
      setState(() {
        searchResult= matchingItems;
        print(searchResult);
      });
    } else {
      print('No matching items found');
    }
  }
final cont=TextEditingController();
final quantityController= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              style: const TextStyle(color: Colors.black),
              cursorColor: Colors.black,
              textInputAction: TextInputAction.next,
              controller: cont,
              decoration: InputDecoration(
                hintText: 'Search for Medicines',
                labelText: 'Medicine Name',
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
                hintStyle: const TextStyle(color: Colors.black),
                labelStyle: const TextStyle(color: Colors.black),

              ),
              autovalidateMode: AutovalidateMode.always,
              onChanged:(value) {
                searchMedList(value);
              },
              validator: (name) => name!.length == 0? 'Enter a valid name' : null,
            ),
    ),

          Expanded(
            child: ListView.builder(
              itemCount: searchResult.length,
              itemBuilder: (context, index) {
                print("All Fine till here");
                Map<String, dynamic> price_quantitymap = searchResult[index].value;
                print(price_quantitymap);
                return ListTile(
                  title: Text(searchResult[index].key),
                  onTap: () {
                    int medicineDescription = 0;
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            title: Text("Buy ${searchResult[index].key}"),
                            content: Column(
                              children: [
                                TextFormField(
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    onChanged: ($Quantity) {


                                  },
                                  controller: quantityController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                   FilteringTextInputFormatter.digitsOnly
                                ],
                                  decoration: const InputDecoration(labelText: 'Quantity'),
                                  validator: (value) {
                                    if (value?.isEmpty ?? true) {
                                      return 'Please enter a quantity';
                                    } else if (int.parse(value.toString()) > price_quantitymap['Quantity']) {
                                      return "Max quantity allowed is" + price_quantitymap['Quantity'].toString();
                                    }
                                    medicineDescription = int.parse(value.toString());
                                    return null;
                                  },
                                  onSaved: (value) {
                                    medicineDescription = int.parse(value.toString());
                                  },
                                ),
                                // ignore: prefer_interpolation_to_compose_strings
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                              title: Text("Confirm Order for ${searchResult[index].key}"),
                                              content: Column(children: [
                                                Text("Quantity: $medicineDescription"),
                                                Text(
                                                    "Original Price: ${medicineDescription / 10.0 * price_quantitymap['Price']}"),
                                                Text(
                                                    "Discount:${medicineDescription / 10.0 * price_quantitymap['Price'] * 0.2}"),
                                                Text(
                                                    "Amount Payable: ${medicineDescription / 10.0 * price_quantitymap['Price'] * 0.8}")
                                              ]),
                                              actions: [
                                                TextButton(
                                                  child: Text("OK"),
                                                  onPressed: () async {
                                                    await DatabaseService(
                                                        uid: FirebaseAuth
                                                            .instance.currentUser!.uid)
                                                        .updateList(
                                                      searchResult[index].key,
                                                        medicineDescription * -1, price_quantitymap['Price']);

                                                    await DatabaseService(
                                                        uid: FirebaseAuth
                                                            .instance.currentUser!.uid)
                                                        .updateUserProfit(

                                                        medicineDescription /
                                                            10 *
                                                            price_quantitymap['Price'] *
                                                            -0.8);
                                                    await DatabaseService(
                                                        uid: FirebaseAuth
                                                            .instance.currentUser!.uid)
                                                        .updateOrder(
                                                        searchResult[index].key,
                                                        medicineDescription,
                                                        medicineDescription /
                                                            10 *
                                                            price_quantitymap['Price'] *
                                                            0.8);
                                                    navigatorKey.currentState!.popUntil((route) => route.isFirst);
                                                  },
                                                ),
                                                TextButton(
                                                    child: Text("Cancel"),
                                                    onPressed: () {
                                                      navigatorKey.currentState!.popUntil((route) => route.isFirst);
                                                    })
                                              ]);
                                        });
                                  })
                            ]);
                      },
                    );
                  },

                );
              },
            ),
          ),
        ],
      ),
    );
  }
}