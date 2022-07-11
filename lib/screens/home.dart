import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'productsscreen.dart';
import 'signup.dart';
import 'materiallistscreen.dart';

class Home extends StatefulWidget {
  final String? uid;
  const Home({Key? key, this.uid}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  _HomeState();
  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child("Users");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          constraints: BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/main.png'), fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 110,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.grey[600]),
                  child: Text("Products"),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InventoryScreen(uid: widget.uid)));
                  },
                ),
              ),
              SizedBox(
                width: 110,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.grey[600]),
                  child: Text(
                    "Materials",
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MaterialListScreen(uid: widget.uid)));
                  },
                ),
              ),
              SizedBox(
                width: 110,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.grey[600]),
                  child: Text(
                    "Log Out",
                  ),
                  onPressed: () async {
                    FirebaseAuth auth = FirebaseAuth.instance;
                    auth.signOut().then((res) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp()),
                          (Route<dynamic> route) => false);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
