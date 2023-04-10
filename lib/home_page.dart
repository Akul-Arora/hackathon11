import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trijalsrimal/delivery.dart';
import 'Components/menu.dart';
import 'Components/firebase.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if(FirebaseAuth.instance.currentUser!.email!.startsWith("trialxcode")){
      return Delivery();
    }
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
          title: Text('MediSell')
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to MediSell!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'Buy and sell unused medication at a lower price',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Navigate to medication listings page
                Navigator.pushNamed(context, '/medication_listings');
              },
              child: Text('Browse Medications'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to sell medication page
                Navigator.pushNamed(context, '/sell_medication');
              },
              child: Text('Sell Medication'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to my earnings page
                Navigator.pushNamed(context, '/my_earnings');
              },
              child: Text('My Earnings'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to feedback/complaint page
                Navigator.pushNamed(context, '/feedback_complaint');
              },
              child: Text('Feedback/Complaint'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to feedback/complaint page
                Navigator.pushNamed(context, '/pending_orders');
              },
              child: Text('Pending Orders'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to feedback/complaint page
                Navigator.pushNamed(context, '/selling_orders');
              },
              child: Text('Selling Orders'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}