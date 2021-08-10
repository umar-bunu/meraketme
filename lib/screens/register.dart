import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

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
      appBar: AppBar(),
      body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  'Benim',
                  style: TextStyle(fontSize: 32),
                ),
                Text(
                  'Taksim',
                  style: TextStyle(fontSize: 30, color: Colors.grey[850]),
                ),
                SizedBox(
                  height: _height * 0.05,
                ),
                TextFormField(
                  autocorrect: false,
                  decoration: const InputDecoration(
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
                const SizedBox(
                  height: 18,
                ),
                TextFormField(
                  autocorrect: false,
                  decoration: const InputDecoration(
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
                TextFormField(
                  obscureText: true,
                  autocorrect: false,
                  decoration: const InputDecoration(
                      hintText: '********',
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.black)),
                  onChanged: (String value) {
                    _password = value.trim();
                  },
                  validator: (String? value) {
                    if (value!.trim().isEmpty) return 'password is required';
                  },
                ),
                const SizedBox(
                  height: 18,
                ),
                TextFormField(
                  obscureText: true,
                  autocorrect: false,
                  decoration: const InputDecoration(
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
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      if (this._password != this._passwordConfirm) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text('Paswords do not match'),
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
                      } catch (e) {}
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content:
                                  const Text('Success! user has been created'),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  const Home()));
                                    },
                                    child: const Text('Continue'))
                              ],
                            );
                          });
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                            (states) => Colors.yellow)),
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    )),
                SizedBox(
                  height: _height * 0.05,
                ),
              ],
            ),
          )),
    );
  }
}
