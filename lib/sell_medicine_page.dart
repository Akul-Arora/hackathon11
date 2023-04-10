import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trijalsrimal/Components/firebase.dart';
import 'package:trijalsrimal/main.dart';
import 'package:trijalsrimal/search.dart';

import 'Components/menu.dart';

class SellMedicinePage extends StatefulWidget {
  const SellMedicinePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SellMedicinePageState createState() => _SellMedicinePageState();
}

class _SellMedicinePageState extends State<SellMedicinePage> {
  final _formKey = GlobalKey<FormState>();
  String? _medicineName;
  String? _medicineDescription;
  double? _medicinePrice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text('Sell Medication'),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Medicine Name',
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
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a medicine name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _medicineName = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                decoration: InputDecoration(
                  hintText: 'Quantity',
                  labelText: 'Quantity',
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
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a quantity';
                  }
                  return null;
                },
                onSaved: (value) {
                  _medicineDescription = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration:
                InputDecoration(
                  hintText: 'Price',
                  labelText: 'Price',
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
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value!) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _medicinePrice = double.parse(value!);
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                   /* await DatabaseService(
                            uid: FirebaseAuth.instance.currentUser!.uid)
                        .updateList(
                            _medicineName.toString().toUpperCase(),
                            int.parse(_medicineDescription.toString()),
                            _medicinePrice!.toInt());

                    await DatabaseService(
                            uid: FirebaseAuth.instance.currentUser!.uid)
                        .updateUserProfit(
                            ((int.parse(_medicineDescription.toString()) /
                                        10.0) *
                                    _medicinePrice!) /
                                2);
                    navigatorKey.currentState!
                        .popUntil((route) => route.isFirst);*/
                    await DatabaseService(
                        uid: FirebaseAuth
                            .instance.currentUser!.uid)
                        .updateSellingOrder(
                        _medicineName.toString().toUpperCase(),
                        int.parse(_medicineDescription.toString()),
                        _medicinePrice!.toInt()*0.05*int.parse(_medicineDescription.toString()),
                        );
                    navigatorKey.currentState!
                        .popUntil((route) => route.isFirst);
                  }
                },
                child: const Text('Sell Medication'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
