import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home.dart';
import 'register.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  final payload;
  const Login({Key? key, this.payload}) : super(key: key);

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
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'MerakEtme',
          style: GoogleFonts.encodeSans(fontSize: 24),
        ),
        elevation: 0,
      ),
      body: Container(
        color: Colors.purple,
        child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(50), topLeft: Radius.circular(50)),
              color: Colors.white.withOpacity(1.0),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(25),
            child: Form(
              key: _formKey,
              child: Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: _height * 0.1,
                  ),
                  const Text(
                    'Merak',
                    style: TextStyle(fontSize: 34),
                  ),
                  Text(
                    'Etme',
                    style: TextStyle(fontSize: 48, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 10),
                  Text('Stay home, we bring it to your door step.',
                      style: GoogleFonts.shadowsIntoLight(fontSize: 18)),
                  SizedBox(
                    height: _height * 0.08,
                  ),
                  Theme(
                    data: ThemeData(
                      primaryColor: Colors.purple,
                      primaryColorDark: Colors.purple,
                    ),
                    child: TextFormField(
                      autocorrect: false,
                      decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple)),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple)),
                          icon: Icon(
                            Icons.email_rounded,
                            color: Colors.purple,
                          ),
                          hintText: 'user@email.com',
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.black)),
                      onChanged: (String value) {
                        _email = value.trim();
                      },
                      validator: (String? value) {
                        if (value!.trim().isEmpty) return 'Email is required';
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Theme(
                    data: ThemeData(
                      primaryColor: Colors.purple,
                      primaryColorDark: Colors.purple,
                    ),
                    child: TextFormField(
                      obscureText: true,
                      autocorrect: false,
                      decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple)),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple)),
                          icon: Icon(
                            Icons.lock_rounded,
                            color: Colors.purple,
                          ),
                          hintText: '********',
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.black)),
                      onChanged: (String value) {
                        _password = value.trim();
                      },
                      validator: (String? value) {
                        if (value!.trim().isEmpty)
                          return 'Password is required';
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;
                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: _email, password: _password);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      widget.payload != null
                                          ? Home(
                                              payload: widget.payload,
                                            )
                                          : const Home()));
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
                                                MaterialStateProperty
                                                    .resolveWith((states) =>
                                                        Colors.purple)),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Okay',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ))
                                  ],
                                );
                              });
                        }
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.resolveWith((states) =>
                              const EdgeInsets.symmetric(vertical: 15)),
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.purple)),
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                  SizedBox(
                    height: _height * 0.025,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              String email = '';
                              String errorInput = '';
                              return AlertDialog(
                                content: SizedBox(
                                  height: 100,
                                  child: Column(
                                    children: [
                                      TextField(
                                        autocorrect: false,
                                        onChanged: (value) {
                                          email = value.trim();
                                        },
                                        decoration: const InputDecoration(
                                          hintText: 'Your email',
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      errorInput.isEmpty
                                          ? const SizedBox()
                                          : Text(
                                              errorInput,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Colors.red),
                                            )
                                    ],
                                  ),
                                ),
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty
                                                      .resolveWith((states) =>
                                                          Colors.red)),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancel')),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty
                                                      .resolveWith((states) =>
                                                          Colors.purple)),
                                          onPressed: () async {
                                            await FirebaseAuth.instance
                                                .sendPasswordResetEmail(
                                                    email: email);
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Ok')),
                                    ],
                                  )
                                ],
                              );
                            });
                      },
                      child: const Text(
                        'Forgot Password',
                        style: TextStyle(
                            decoration: TextDecoration.underline, fontSize: 16),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.025,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const Register()));
                      },
                      child: const Text(
                        "New user? Register",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: _height * 0.05,
                  ),
                  const Flexible(
                      child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text('Developed by Githarita'),
                  ))
                ],
              ),
            )),
      ),
    );
  }
}
