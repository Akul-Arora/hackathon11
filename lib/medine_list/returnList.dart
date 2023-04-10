import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trijalsrimal/Components/firebase.dart';

class List_return extends StatelessWidget {
  const List_return({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<DocumentSnapshot?>(context);

    Map<String, dynamic> data = {};
    if (user != null) {
      data = user.data() as Map<String, dynamic>;
    } else {
      return const CircularProgressIndicator();
    }

    return _buildMedicineList(data['med_list'], context);
  }
}

Widget _buildMedicineTile(
    String name, int price, int quantity, BuildContext context) {
  final quantityController = TextEditingController();
  return ListTile(
    title: Text(name),
    subtitle: Text('Price for 10 units: $price, Quantity Available: $quantity'),
    onTap: () {
      int medicineDescription = 0;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Buy $name"),
              content: Column(
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (value) {
                      medicineDescription = int.parse(value.toString());
                      print(medicineDescription);
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
                      } else if (int.parse(value.toString()) > quantity) {
                        return "Max quantity allowed is" + quantity.toString();
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
                                title: Text("Confirm Order for $name"),
                                content: Column(children: [
                                  Text("Quantity: $medicineDescription"),
                                  Text(
                                      "Original Price: ${medicineDescription / 10.0 * price}"),
                                  Text(
                                      "Discount:${medicineDescription / 10.0 * price * 0.2}"),
                                  Text(
                                      "Amount Payable: ${medicineDescription / 10.0 * price * 0.8}")
                                ]),
                                actions: [
                                  TextButton(
                                    child: Text("OK"),
                                    onPressed: () async {
                                      await DatabaseService(
                                              uid: FirebaseAuth
                                                  .instance.currentUser!.uid)
                                          .updateList(name.toUpperCase(),
                                              medicineDescription * -1, price);
                                      await DatabaseService(
                                              uid: FirebaseAuth
                                                  .instance.currentUser!.uid)
                                          .updateUserProfit(
                                              medicineDescription /
                                                  10 *
                                                  price *
                                                  -0.8);
                                      await DatabaseService(
                                              uid: FirebaseAuth
                                                  .instance.currentUser!.uid)
                                          .updateOrder(
                                              name.toUpperCase(),
                                              medicineDescription,
                                              medicineDescription /
                                                  10 *
                                                  price *
                                                  0.8);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                      child: Text("Cancel"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      })
                                ]);
                          });
                    })
              ]);
        },
      );
    },
  );
}

// Create a ListView of tiles by mapping each medicine to a ListTile widget
ListView _buildMedicineList(Map medicinesMap, context) {
  return ListView(
    children: medicinesMap.entries
        .map((medicine) => _buildMedicineTile(medicine.key,
            medicine.value['Price']!, medicine.value['Quantity']!, context))
        .toList(),
  );
}
