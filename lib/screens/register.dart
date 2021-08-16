import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _passwordConfirm = '';
  String _nameSurname = '';

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
                    style: TextStyle(fontSize: 32),
                  ),
                  Text(
                    'Etme',
                    style: TextStyle(fontSize: 48, color: Colors.grey[850]),
                  ),
                  SizedBox(
                    height: _height * 0.05,
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
                          hintText: 'user@email.com',
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.black)),
                      onChanged: (String value) {
                        _email = value.trim();
                      },
                      validator: (String? value) {
                        if (value!.trim().isEmpty) return 'email is required';
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
                      autocorrect: false,
                      decoration: const InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple)),
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple)),
                          hintText: 'Merak Etme',
                          labelText: 'Name Surname',
                          labelStyle: TextStyle(color: Colors.black)),
                      onChanged: (String value) {
                        _nameSurname = value.trim();
                      },
                      validator: (String? value) {
                        if (value!.trim().isEmpty) {
                          return 'Please fill in this field';
                        }
                      },
                    ),
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
                          hintText: '********',
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.black)),
                      onChanged: (String value) {
                        _password = value.trim();
                      },
                      validator: (String? value) {
                        if (value!.trim().isEmpty)
                          return 'password is required';
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
                          hintText: '********',
                          labelText: 'Confirm password',
                          labelStyle: TextStyle(color: Colors.black)),
                      onChanged: (String value) {
                        _passwordConfirm = value.trim();
                      },
                      validator: (String? value) {
                        if (value!.trim().isEmpty) return 'Field is required';
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;
                        if (_password != _passwordConfirm) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: const Text('Paswords do not match'),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Okay'))
                                  ],
                                );
                              });
                          return;
                        }
                        try {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: _email, password: _password);
                          await FirebaseAuth.instance.currentUser!
                              .updateDisplayName(_nameSurname);
                        } catch (e) {
                          print('e');
                        }
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: const Text(
                                    'Success! user has been created'),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        const Home()));
                                      },
                                      child: const Text('Continue'))
                                ],
                              );
                            });
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.resolveWith((states) =>
                              const EdgeInsets.symmetric(vertical: 10.0)),
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.purple)),
                      child: const Text(
                        'Register',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                  SizedBox(
                    height: _height * 0.05,
                  ),
                  const Flexible(
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text('Developed by Githarita')))
                ],
              ),
            )),
      ),
    );
  }
}
