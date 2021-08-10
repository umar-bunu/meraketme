import 'home.dart';
import 'register.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                const Text(
                  'Merak',
                  style: TextStyle(fontSize: 34),
                ),
                Text(
                  'Etme',
                  style: TextStyle(fontSize: 48, color: Colors.grey[850]),
                ),
                SizedBox(
                  height: _height * 0.1,
                ),
                TextFormField(
                  autocorrect: false,
                  decoration: InputDecoration(
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFBC02D))),
                      border: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFF9A825))),
                      icon: Theme(
                        data: Theme.of(context).copyWith(
                            primaryColor: const Color(0xFFF9A825),
                            primaryIconTheme:
                                const IconThemeData(color: Color(0xFFF9A825))),
                        child: const Icon(
                          Icons.email_rounded,
                        ),
                      ),
                      hintText: 'user@email.com',
                      labelText: 'Email',
                      labelStyle: const TextStyle(color: Colors.black)),
                  onChanged: (String value) {
                    _email = value.trim();
                  },
                  validator: (String? value) {
                    if (value!.trim().isEmpty) return 'Email is required';
                  },
                ),
                const SizedBox(
                  height: 18,
                ),
                TextFormField(
                  obscureText: true,
                  autocorrect: false,
                  decoration: InputDecoration(
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFBC02D))),
                      border: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFBC02D))),
                      icon: Theme(
                        data: Theme.of(context).copyWith(
                            primaryColor: Color(0xFFF9A825),
                            primaryIconTheme:
                                const IconThemeData(color: Color(0xFFF9A825))),
                        child: const Icon(
                          Icons.lock_rounded,
                        ),
                      ),
                      hintText: '********',
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Colors.black)),
                  onChanged: (String value) {
                    _password = value.trim();
                  },
                  validator: (String? value) {
                    if (value!.trim().isEmpty) return 'Password is required';
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: _email, password: _password);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const Home()));
                      } on FirebaseAuthException catch (e) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              print(e.toString());
                              return AlertDialog(
                                title: const Text('Something went wrong\n'),
                                content: Text(e.code.toString()),
                                actions: [
                                  ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.resolveWith(
                                                  (states) => Colors.yellow)),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        'Okay',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18),
                                      ))
                                ],
                              );
                            });
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.yellow)),
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    )),
                SizedBox(
                  height: _height * 0.05,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Register()));
                    },
                    child: const Text(
                      "New user? Register",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(
                  height: _height * 0.05,
                )
              ],
            ),
          )),
    );
  }
}
