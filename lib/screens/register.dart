import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:meraketme/services/OtherServices.dart';
import 'package:meraketme/widgets/bottombarWidget.dart';
import '../services/globals.dart' as globals;
import 'home.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  int _isLoading = 0;

  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _passwordConfirm = '';
  String _nameSurname = '';
  String _phoneNo = '';
  String _selectedState = '';
  String _selectedLGA = '';
  List _states = [];
  Future _getData() async {
    try {
      if (mounted) {
        setState(() async {
          _states = await OtherServices().getStates();
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint('all keys: ' + globals.states.elementAt(0).keys.toString());
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              color: Colors.purple,
              child: Scrollbar(
                isAlwaysShown: true,
                thickness: 0.7,
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(50),
                          topLeft: Radius.circular(50)),
                      color: Colors.white.withOpacity(1.0),
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        shrinkWrap: true,
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
                            style: TextStyle(
                                fontSize: 48, color: Colors.grey[850]),
                          ),
                          const Align(
                            heightFactor: 1.5,
                            alignment: Alignment.bottomCenter,
                            child: Text('User SignUp',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w500)),
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
                                  icon: Icon(Icons.email, color: Colors.purple),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.purple)),
                                  border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.purple)),
                                  hintText: 'user@email.com',
                                  labelText: 'Email',
                                  labelStyle: TextStyle(color: Colors.black)),
                              onChanged: (String value) {
                                _email = value.trim();
                              },
                              validator: (String? value) {
                                if (value!.trim().isEmpty)
                                  return 'email is required';
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
                                  focusColor: Colors.purple,
                                  icon:
                                      Icon(Icons.person, color: Colors.purple),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.purple)),
                                  border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.purple)),
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
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]'))
                              ],
                              autocorrect: false,
                              decoration: InputDecoration(
                                  prefix: const Text('+'),
                                  focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.purple)),
                                  border: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.purple)),
                                  icon: const Icon(
                                    Icons.phone,
                                    color: Colors.purple,
                                  ),
                                  hintText: _phoneNo.isEmpty
                                      ? '0123456789...'
                                      : _phoneNo.replaceFirst('+', ''),
                                  labelText: 'Phone no',
                                  labelStyle:
                                      const TextStyle(color: Colors.black)),
                              onChanged: (String value) {
                                _phoneNo = value.trim();
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
                                  icon: Icon(Icons.password,
                                      color: Colors.purple),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.purple)),
                                  border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.purple)),
                                  hintText: '********',
                                  labelText: 'Password',
                                  labelStyle: TextStyle(color: Colors.black)),
                              onChanged: (String value) {
                                _password = value.trim();
                              },
                              validator: (String? value) {
                                if (value!.trim().isEmpty) {
                                  return 'password is required';
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
                                  icon: Icon(Icons.password,
                                      color: Colors.purple),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.purple)),
                                  border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.purple)),
                                  hintText: '********',
                                  labelText: 'Confirm password',
                                  labelStyle: TextStyle(color: Colors.black)),
                              onChanged: (String value) {
                                _passwordConfirm = value.trim();
                              },
                              validator: (String? value) {
                                if (value!.trim().isEmpty)
                                  return 'Field is required';
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TypeAheadFormField(
                              validator: (value) {
                                var tempList = globals.states.where((element) =>
                                    element.keys.first
                                        .toLowerCase()
                                        .contains(value!.trim().toLowerCase()));
                                if (tempList.isEmpty) {
                                  return 'State not found';
                                }
                              },
                              textFieldConfiguration: TextFieldConfiguration(
                                  decoration: const InputDecoration(
                                      icon:
                                          Icon(Icons.map, color: Colors.purple),
                                      labelText: 'State',
                                      enabledBorder: UnderlineInputBorder(),
                                      border: UnderlineInputBorder(),
                                      focusedBorder: UnderlineInputBorder()),
                                  controller: TextEditingController(
                                      text: _selectedState)),
                              suggestionsCallback: (pattern) async {
                                if (pattern.isNotEmpty) {
                                  return await OtherServices()
                                      .getStatePattern(pattern);
                                } else {
                                  return [];
                                }
                              },
                              itemBuilder: (_, item) {
                                return Text(
                                  item.toString(),
                                  style: const TextStyle(fontSize: 16),
                                );
                              },
                              onSuggestionSelected: (suggestion) {
                                setState(() {
                                  _selectedState = suggestion
                                      .toString()
                                      .replaceFirst(
                                          suggestion.toString().substring(0, 1),
                                          suggestion
                                              .toString()
                                              .substring(0, 1)
                                              .toUpperCase());
                                });
                              }),
                          const SizedBox(
                            height: 10,
                          ),
                          TypeAheadFormField(
                              validator: (value) {
                                var tempList = globals.states
                                    .where((element) => element.keys.first
                                        .toLowerCase()
                                        .contains(_selectedState.toLowerCase()))
                                    .first
                                    .values
                                    .first
                                    .where((element) => element
                                        .toString()
                                        .toLowerCase()
                                        .contains(value!.trim().toLowerCase()));
                                if (tempList.isEmpty) {
                                  return 'L.G.A not found';
                                }
                              },
                              textFieldConfiguration: TextFieldConfiguration(
                                  decoration: const InputDecoration(
                                      icon:
                                          Icon(Icons.map, color: Colors.purple),
                                      labelText: 'L.G.A',
                                      enabledBorder: UnderlineInputBorder(),
                                      border: UnderlineInputBorder(),
                                      focusedBorder: UnderlineInputBorder()),
                                  controller: TextEditingController(
                                      text: _selectedLGA)),
                              suggestionsCallback: (pattern) async {
                                if (pattern.isNotEmpty) {
                                  return await OtherServices()
                                      .getLgaPattern(_selectedState, pattern);
                                } else {
                                  return [];
                                }
                              },
                              itemBuilder: (_, item) {
                                return Text(
                                  item.toString(),
                                  style: const TextStyle(fontSize: 16),
                                );
                              },
                              onSuggestionSelected: (suggestion) {
                                setState(() {
                                  _selectedLGA = suggestion
                                      .toString()
                                      .replaceFirst(
                                          suggestion.toString().substring(0, 1),
                                          suggestion
                                              .toString()
                                              .substring(0, 1)
                                              .toUpperCase());
                                });
                              }),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Login()));
                              },
                              child: const Text(
                                  'Already have an account? Login',
                                  style: TextStyle(
                                      decoration: TextDecoration.underline)),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                if (_isLoading != 0) return;

                                if (!_formKey.currentState!.validate()) return;

                                if (_password != _passwordConfirm) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: const Text(
                                              'Paswords do not match'),
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
                                var _token =
                                    await FirebaseMessaging.instance.getToken();
                                setState(() {
                                  _isLoading = 1;
                                });
                                try {
                                  await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                          email: _email, password: _password);
                                  await FirebaseAuth.instance.currentUser!
                                      .updateDisplayName(_nameSurname);
                                  setState(() {
                                    _isLoading = 2;
                                  });
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.email)
                                      .set({
                                    'email': FirebaseAuth
                                        .instance.currentUser!.email,
                                    'state': _selectedState,
                                    'lga': _selectedLGA,
                                    'token': _token ?? '',
                                    'phone': '+' + _phoneNo,
                                    'isVendor': false,
                                  });
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BottomBarWidget()));
                                } on FirebaseAuthException catch (e) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: Text('Ooops'),
                                            content: Text(_isLoading == 2
                                                ? 'User has been created.\n'
                                                    'Could not upload user data.\n This can be done later in settings'
                                                : 'Could not create User.\n'
                                                    '${e.code}\nPlease try again later.'),
                                            actions: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    _isLoading == 2
                                                        ? Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        BottomBarWidget()))
                                                        : Navigator.pop(
                                                            context);
                                                  },
                                                  child: const Text('Okay'))
                                            ],
                                          ));
                                }

                                setState(() {
                                  _isLoading = 0;
                                });
                              },
                              style: ButtonStyle(
                                  padding: MaterialStateProperty.resolveWith(
                                      (states) => const EdgeInsets.symmetric(
                                          vertical: 10.0)),
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) => Colors.purple)),
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )),
                          SizedBox(
                            height: _height * 0.05,
                          ),
                          const Align(
                              alignment: Alignment.bottomCenter,
                              child: Text('Developed by Githarita'))
                        ],
                      ),
                    )),
              ),
            ),
            _isLoading > 0
                ? Container(
                    height: _height,
                    width: _width,
                    alignment: Alignment.center,
                    color: Colors.white.withOpacity(0.2),
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      height: 100,
                      width: _width * 0.7,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: AnimatedTextKit(
                        repeatForever: true,
                        animatedTexts: [
                          FadeAnimatedText(
                              _isLoading == 1
                                  ? 'Creating user'
                                  : 'Updating user profile',
                              textStyle: const TextStyle(fontSize: 22)),
                          FadeAnimatedText('Please wait...',
                              textStyle: const TextStyle(fontSize: 22))
                        ],
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        ));
  }
}
