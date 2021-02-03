import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "../services/auth.dart";
import "package:flutter/material.dart";

class LoginScreen extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const LoginScreen({Key key, @required this.auth, @required this.firestore}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Padding(
                padding: const EdgeInsets.all(60.0),
                child: Builder(
                  builder: (BuildContext context) {
                    return Column(
                      children: <Widget>[
                        TextFormField(
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(hintText: "Username"),
                            controller: _emailController),
                        TextFormField(
                          obscureText: true,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(hintText: "Password"),
                          controller: _passwordController,
                        ),
                        const SizedBox(height: 20.0),
                        RaisedButton(
                            onPressed: () async {
                              final String logValue = await Auth(auth: widget.auth)
                                  .login(email: _emailController.text, password: _passwordController.text);
                              if (logValue == "Sucess") {
                                _emailController.clear();
                                _passwordController.clear();
                              } else {
                                Scaffold.of(context).showSnackBar(SnackBar(content: Text(logValue)));
                              }
                            },
                            child: const Text("Login")),
                        FlatButton(
                            onPressed: () async {
                              final String regValue = await Auth(auth: widget.auth)
                                  .createAccount(email: _emailController.text, password: _passwordController.text);

                              if (regValue == "Sucess") {
                                _emailController.clear();
                                _passwordController.clear();
                              } else {
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(regValue),
                                ));
                              }
                            },
                            child: const Text("Create Account"))
                      ],
                    );
                  },
                ))));
  }
}
