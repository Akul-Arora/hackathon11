// ignore_for_file: non_constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference medicineCollection =
      FirebaseFirestore.instance.collection('medicine');

  Future<void> setInitialUserData(
      int phone, String Name, String address, String email) async {
    return await medicineCollection.doc(uid).set({
      'Name': Name,
      'Email': email,
      'Phone': phone,
      'Registration No.': address,
      'Profit': 0.0,
    });
  }

  Future<void> updateList(String name, int quantity, int price) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('medicine').doc('medicine');

// Define the new medicine you want to add to the existing map
    String newMedicine = name;
    int newPrice = price;
    int newQuantity = quantity;

    docRef.get().then((docSnapshot) {
      if (docSnapshot.exists && docSnapshot.data() != null) {
        Map<String, dynamic> medListo =
            docSnapshot.data() as Map<String, dynamic>;
        Map medList = medListo["med_list"];
        if (medList.containsKey(newMedicine)) {
          // The medicine already exists in the map, so update its quantity
          int currentQuantity = medList[newMedicine]['Quantity'];
          docRef.update({
            'med_list.$newMedicine.Quantity': newQuantity + currentQuantity
          });
        } else {
          // The medicine does not exist in the map, so add it with the new price and quantity
          docRef.update({
            'med_list.$newMedicine': {
              'Price': newPrice,
              'Quantity': newQuantity
            }
          });
        }
      }
    });
// Note that the update() method with FieldValue.increment() will add the new key-value pair to the existing map, but will also increment the quantity value if the key already exists
  }

  Future<void> updateOrder(String name, int quantity, double amount) async {
    int orderno = 0;
    DocumentReference docRef1 =
        FirebaseFirestore.instance.collection('pending_orders').doc('OrderNo');
    docRef1.get().then((docSnapshot) {
      if (docSnapshot.exists && docSnapshot.data() != null) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        orderno = data['Last'] + 1;
        docRef1.set({'Last': orderno});
        DocumentReference docRef = FirebaseFirestore.instance
            .collection('pending_orders')
            .doc('pending_orders');
        docRef.get().then((docSnapshot) {
          docRef.update({
            'pending_orders.$orderno': {
              "Name": FirebaseAuth.instance.currentUser!.displayName,
              'Uid': FirebaseAuth.instance.currentUser!.uid,
              'Medicine name': name,
              'Medicine Quantity': quantity,
              'Order Amount': amount
            }
          });
        });
      }
    });
  }

  Future<void> updateSellingOrder(String name, int quantity, double amount) async {
    int orderno = 0;
    DocumentReference docRef1 =
    FirebaseFirestore.instance.collection('selling_orders').doc('OrderNo');
    docRef1.get().then((docSnapshot) {
      if (docSnapshot.exists && docSnapshot.data() != null) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        orderno = data['Last'] + 1;
        docRef1.set({'Last': orderno});
        DocumentReference docRef = FirebaseFirestore.instance
            .collection('selling_orders')
            .doc('selling_orders');
        docRef.get().then((docSnapshot) {
          docRef.update({
            'selling_orders.$orderno': {
              "Name": FirebaseAuth.instance.currentUser!.displayName,
              'Uid': FirebaseAuth.instance.currentUser!.uid,
              'Medicine name': name,
              'Medicine Quantity': quantity,
              'Order Amount': amount
            }
          });
        });
      }
    });
  }

  Future<void> updateUserProfit(double profit) async {
    return await medicineCollection.doc(uid).update({
      'Profit': FieldValue.increment(profit),
    });
  }

  Stream<DocumentSnapshot> get user_details {
    return medicineCollection.doc(uid).snapshots();
  }

  Stream<DocumentSnapshot> get medicine_list {
    return medicineCollection.doc("medicine").snapshots();
  }

  Stream<QuerySnapshot> get Leaders {
    return medicineCollection
        .orderBy('Points', descending: true)
        .limit(3)
        .snapshots();
  }
}
