// ignore: duplicate_ignore
// ignore: file_names

// ignore_for_file: file_names
//nav bar drawer
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:trijalsrimal/feed.dart';
import 'package:trijalsrimal/main.dart';
import 'package:trijalsrimal/medine_list/medList.dart';
import 'package:trijalsrimal/my_earnings_page.dart';
import 'package:trijalsrimal/sell_medicine_page.dart';
import 'package:trijalsrimal/selling_orders.dart';
import '../home_page.dart';
import 'package:trijalsrimal/pending_orders.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  Future<void> navigateToHome(context) async {
    Navigator.push(
        context,
        PageTransition(
          child: HomePage(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 500),
        ));
  }

  Future<void> navigateToResources(context) async {
    Navigator.push(
        context,
        PageTransition(
          child: MedicineListingPage(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 500),
        ));
  }

  Future<void> navigateToFAQ(context) async {
    Navigator.push(
        context,
        PageTransition(
          child: FeedbackComplaintPage(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 500),
        ));
  }

  Future<void> navigateToProfile(context) async {
    Navigator.push(
        context,
        PageTransition(
          child: MyEarningsPage(
            earnings: 200.0,
          ),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 500),
        ));
  }

  Future<void> navigateToSell(context) async {
    Navigator.push(
        context,
        PageTransition(
          child: SellMedicinePage(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 500),
        ));
  }
  Future<void> navigateToPending(context) async {
    Navigator.push(
        context,
        PageTransition(
          child: PendingOrdersPage(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 500),
        ));
  }
  Future<void> navigateToSelling(context) async {
    Navigator.push(
        context,
        PageTransition(
          child: SellingOrdersPage(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 500),
        ));
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    //this checks the internet connection everywhere in app and as soon as internet goes off,
    //as this widget is the common link to evry page in the app, pops to the main route, where no internet connection is handled by main.dart
    StreamSubscription streamSubscription =
    Connectivity().onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.wifi) {
        //rate 5 stars, do nothing
      } else if (event == ConnectivityResult.mobile) {
        //rate 5 stars, do nothing
      } else if (event == ConnectivityResult.ethernet) {
        //rate 5 stars, do nothing
      } else if (event == ConnectivityResult.vpn) {
        //rate 5 stars, do nothing
      } else {
        navigatorKey.currentState!.popUntil((route) => route.isFirst);
      }
    });
    final user = FirebaseAuth.instance.currentUser;
    String? name = FirebaseAuth.instance.currentUser?.displayName == null
        ? "N/A"
        : FirebaseAuth.instance.currentUser!.displayName.toString();
    String email = user!.email != null ? user.email.toString() : "N/A";
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(name),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Icon(Icons.account_circle, size: 70,),
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => navigateToHome(context),
          ),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text('Earnings'),
            onTap: () => navigateToProfile(context),
          ),

          ListTile(
            leading: const Icon(Icons.sell),
            title: const Text('Sell Medicines'),
            onTap: () {
              navigateToSell(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.medical_information_sharp),
            title: const Text('Buy Medicines'),
            onTap: () => navigateToResources(context),
          ),
          ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Pending Orders'),
              onTap: () => navigateToPending(context)),
          ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Selling Orders'),
              onTap: () => navigateToSelling(context)),
          ListTile(
              leading: const Icon(Icons.question_mark),
              title: const Text('FAQ'),
              onTap: () => navigateToFAQ(context)),
          ListTile(
            title: const Text('Log Out'),
            leading: const Icon(Icons.exit_to_app),
            onTap: () {
              navigatorKey.currentState!.popUntil((route) => route.isFirst);
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}