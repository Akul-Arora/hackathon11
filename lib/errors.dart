// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:trijalsrimal/main.dart';

class ErrorHome extends StatefulWidget {
  const ErrorHome({Key? key}) : super(key: key);

  @override
  State<ErrorHome> createState() => _ErrorHomeState();
}

class _ErrorHomeState extends State<ErrorHome> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 40,
        ),
        body: Column(
          children: [
            Flexible(
              flex:1,
              child: Column(children: [

                const SizedBox(height:30),
                const Center(child: Text("Hello User,", style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Sarabun",
                  fontSize: 20,
                )),),
                const SizedBox(height:6),
                const Center(child: Text("Welcome to MediSell!", style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Sarabun",
                  fontSize: 16,
                )),),
                const SizedBox(height:30),
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Container(
                    decoration:  BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50))
                    ),

                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:[
                            Padding(
                              padding:EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.06, MediaQuery.of(context).size.width * 0.06,MediaQuery.of(context).size.width * 0.1,0),
                              child: const Center(
                                child: Text("""We aim to reinvent the medical sector by providing best quality unused medicines at affordable prices.""", textAlign: TextAlign.center,style: TextStyle(
                                  fontFamily: "Sarabun",
                                  fontSize: 24,
                                )),
                              ),
                            ),
                            const Center(
                              child: Text("To start, connect to the internet", textAlign: TextAlign.center,style: TextStyle(
                                fontFamily: "Sarabun",
                                fontSize: 24,
                              )),
                            ),
                            const SizedBox(height: 20),
                            Row(
                                children: <Widget>[
                                  const Expanded(
                                      child: Divider(thickness: 2,color: Colors.black)
                                  ),
                                  Text("No Internet Connection", style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontFamily: "Sarabun",
                                    fontSize: 24,
                                  )),
                                  const Expanded(
                                      child: Divider(thickness: 2,color: Colors.black)
                                  ),

                                ]
                            ),
                            const SizedBox(height: 20),
                            IconButton(onPressed: (){navigatorKey.currentState!.popUntil((route) => route.isFirst);}, icon: const Icon(Icons.refresh, size: 50,)),
                            const SizedBox(height:20),
                            Center(child: Text("""
Check your Internet connection, and then tap to retry""", style: TextStyle(fontSize: 20,color: Theme.of(context).colorScheme.primary,
                              fontFamily: "Sarabun",), textAlign: TextAlign.center,)),

                          ]
                      ),
                    ),
                  ),
                ),
              ]),
            )
          ],
        ));
  }
}