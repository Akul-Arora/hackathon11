/* import 'package:trijalsrimal/sell_medicine_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SellingOrdersPage extends StatefulWidget {
  const SellingOrdersPage({Key? key}) : super(key: key);

  @override
  _SellingOrdersPageState createState() => _SellingOrdersPageState();
}

class _SellingOrdersPageState extends State<SellingOrdersPage> {
  CollectionReference _ordersRef =
  FirebaseFirestore.instance.collection('price_quantitymap');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selling Orders'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _ordersRef.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Widget> orderWidgets = [];
          snapshot.data!.docs.forEach((DocumentSnapshot document) {
            Map<String, dynamic> data =
            document.data() as Map<String, dynamic>;

            orderWidgets.add(Card(
              child: ListTile(
                //title: Text(data['_medicineName']),
                trailing: IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    _ordersRef.doc(document.id).delete();
                  },
                ),
              ),
            ));
          });

          if (orderWidgets.isEmpty) {
            return Center(
              child: Text('You have no selling orders.'),
            );
          }

          return ListView(
            children: orderWidgets,
          );
        },
      ),
    );
  }
}*/
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class SellingOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selling Orders'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('selling_orders')
            .doc('selling_orders')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          Map<String, dynamic>? data = snapshot.data?.data() as Map<String, dynamic>?;
          Map<String, dynamic>? selling_orders = Map<String, dynamic>.from(data?['selling_orders'] ?? {});
          List myOrder = selling_orders.values
              .where((submission) => submission['Name'] == FirebaseAuth.instance.currentUser!.displayName)
              .toList();
          List MyOrderKey=
          selling_orders.keys.where((key) {
            Map<String, dynamic>? abcd=selling_orders[key];
            if(abcd!['Name'] == FirebaseAuth.instance.currentUser!.displayName){
              return true;
            }
            else{
              return false;
            }
          }).toList();
          return ListView.builder(
            itemCount: myOrder.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic>? selling = Map<String, dynamic>.from(myOrder[index]);


              String projectName = selling['Medicine name'];
              String quantity = selling['Medicine Quantity'].toString() ;
              return ListTile(
                title: Text(projectName,style: TextStyle(color: Colors.white,)),
                subtitle: Text(quantity,style: TextStyle(color: Colors.white,)),

                onTap:(){
                  showDialog(
                    context: context,
                    builder: (BuildContext context)=>AlertDialog(

                      actions: [
                        TextButton(onPressed: (){
                          final FirebaseFirestore firestore = FirebaseFirestore.instance;


                          final CollectionReference sellingOrdersCollection = firestore.collection('selling_orders');
                          final DocumentReference sellingOrdersDocument = sellingOrdersCollection.doc('selling_orders');

                          final String keyToDelete = MyOrderKey[index];

                          sellingOrdersDocument.update({
                            'selling_orders.$keyToDelete': FieldValue.delete(),
                          }).then((value) {
                            print('Successfully deleted $keyToDelete');
                          }).catchError((error) {
                            print('Error deleting $keyToDelete: $error');
                          });
                        },
                            child: Text("Cancel Order")),
                        TextButton(onPressed: (){
                          Navigator.pop(context);
                        }, child: Text("Don't Cancel")),
                      ],
                    ),
                  );
                  },
              );
            },
          );
        },
      ),
    );
  }
}