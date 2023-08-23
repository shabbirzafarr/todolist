import 'package:doit/auth/home.dart';
import 'package:doit/noauth/Intro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth=FirebaseAuth.instance;
    return StreamBuilder<User?>(
    stream: _auth.authStateChanges(),
    builder: (BuildContext context, snapshot) {
      if (snapshot.hasData) {
        return home();
      } 
      else {
        return  Intro();
      }
    }
    );
  }
}