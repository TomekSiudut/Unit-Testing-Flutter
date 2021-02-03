import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebaseUnitTests/screens/error_screen.dart';
import 'package:firebaseUnitTests/screens/home_screen.dart';
import 'package:firebaseUnitTests/screens/loading_screen.dart';
import 'package:firebaseUnitTests/screens/login_screen.dart';
import 'package:firebaseUnitTests/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorScreen();
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return Root();
          }

          return LoadingScreen();
        },
      ),
    );
  }
}

class Root extends StatefulWidget {
  Root({Key key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth(auth: _auth).user,
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data?.uid == null) {
              return LoginScreen(auth: _auth, firestore: _firestore);
            } else {
              return HomeScreen(auth: _auth, firestore: _firestore);
            }
          } else {
            return LoadingScreen();
          }
        });
  }
}
