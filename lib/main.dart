import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:trijalsrimal/medine_list/medList.dart';
import 'package:trijalsrimal/my_earnings_page.dart';
import 'package:trijalsrimal/pending_orders.dart';
import 'package:trijalsrimal/sell_medicine_page.dart';
import 'package:trijalsrimal/feed.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trijalsrimal/selling_orders.dart';
import 'Components/customthemes.dart';
import 'Login/auth.dart';
import 'Login/emailVerification.dart';
import 'errors.dart';
import 'firebase_options.dart';
import 'package:trijalsrimal/Login/Login.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Connectivity _connectivity = Connectivity();

  // ignore: unused_field
  late StreamSubscription _streamSubscription;

  @override
  void initState() {

    checkRealtimeConnection();
    super.initState();
  }

  late Widget to_be = const MainPage();

  void checkRealtimeConnection() {
    _streamSubscription = _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
        setState(() {to_be = const ErrorHome();});
      }  else {
        setState(() {to_be = const MainPage();});
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: Mythemes.lightTheme,
      darkTheme: Mythemes.darkTheme,
      navigatorKey: navigatorKey,
      title: 'MediSell',
      home: to_be,
      routes: {
        '/medication_listings': (context) => MedicineListingPage(),
        '/sell_medication': (context) => const SellMedicinePage(),
        '/feedback_complaint': (context) => FeedbackComplaintPage(),
        '/my_earnings': (context) => MyEarningsPage(earnings: 200.0),
        '/pending_orders': (context) => PendingOrdersPage(),
        '/selling_orders': (context) => SellingOrdersPage(),

        // replace 50 with function to display the earnings.
      },
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  //Listening for auth changes from Firebase Auth via streams
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#4169E1"),
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Something Went Wrong!!"),
              );
            } else if (snapshot.hasData) {
              return const VerifyEmailPage();
            } else {
              return const AuthPage();
            }
          }),
    );
  }
}