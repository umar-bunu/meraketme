// ignore_for_file: file_names, must_be_immutable

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:meraketme/screens/login.dart';
import 'package:meraketme/services/FireStoreServices.dart';
import 'package:meraketme/services/OtherServices.dart';
import 'package:meraketme/widgets/showSuccessAlert.dart';

import '../services/globals.dart' as globals;

class Profile extends StatefulWidget {
  var userData;
  Profile({Key? key, this.userData}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _passwordFormKey = GlobalKey<FormState>();
  final _shippingFormKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isShowingSuccessMessage = false;

  String _password = '';
  String _passwordConfirm = '';

  String _phoneNo = '';

  String _errorText = '';
  String _addressErrorText = '';

  String _displayName = '';
  TextEditingController _stateController = TextEditingController();
  TextEditingController _lgaController = TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {
      _phoneNo = widget.userData['data']['phone'] ?? '';
      _lgaController.text = widget.userData['data']['lga'] ?? '';
      _stateController.text = widget.userData['data']['state'] ?? '';
      _displayName = widget.userData['data']['name'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Stack(
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 15,
                ),
                Form(
                  key: _passwordFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(
                        child: Text(
                          'Change Password',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
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
                              labelText: 'New Password',
                              labelStyle: TextStyle(color: Colors.black)),
                          onChanged: (String value) {
                            _password = value.trim();
                          },
                          validator: (String? value) {
                            if (value!.trim().isEmpty) {
                              return 'Password is required';
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
                              icon: Icon(
                                Icons.lock_rounded,
                                color: Colors.purple,
                              ),
                              hintText: '********',
                              labelText: 'Confirm Password',
                              labelStyle: TextStyle(color: Colors.black)),
                          onChanged: (String value) {
                            _passwordConfirm = value.trim();
                          },
                          validator: (String? value) {
                            if (value!.trim().isEmpty) {
                              return 'Field is required';
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      _errorText.isEmpty
                          ? const SizedBox()
                          : SizedBox(
                              height: 20,
                              child: Text(
                                _errorText,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 17, color: Colors.red),
                              ),
                            ),
                      ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _errorText = '';
                            });
                            if (_passwordFormKey.currentState!.validate()) {
                              if (_password == _passwordConfirm) {
                                setState(() {
                                  _isLoading = true;
                                });
                                try {
                                  await FirebaseAuth.instance.currentUser!
                                      .updatePassword(_password);
                                  setState(() {
                                    _isLoading = false;
                                    _isShowingSuccessMessage = true;
                                  });
                                  Timer(const Duration(seconds: 3), () {
                                    setState(() {
                                      _isShowingSuccessMessage = false;
                                    });
                                  });
                                } on FirebaseAuthException catch (e) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  setState(() {
                                    _errorText = e.code;
                                  });
                                }
                              } else {
                                setState(() {
                                  _errorText = 'Passwords do not match';
                                });
                              }
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Update Password',
                              style: TextStyle(fontSize: 18),
                            ),
                          )),
                      const SizedBox(height: 15),
                      const Center(
                        child: Text(
                          'User Details',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Theme(
                        data: ThemeData(
                          primaryColor: Colors.purple,
                          primaryColorDark: Colors.purple,
                        ),
                        child: TextFormField(
                          initialValue: _displayName,
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
                              hintText: 'Merak Etme',
                              labelText: 'Name',
                              labelStyle: TextStyle(color: Colors.black)),
                          onChanged: (String value) {
                            _displayName = value.trim();
                          },
                          validator: (String? value) {
                            if (value!.trim().isEmpty) {
                              return 'Field is required';
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Theme(
                        data: ThemeData(
                          primaryColor: Colors.purple,
                          primaryColorDark: Colors.purple,
                        ),
                        child: TextFormField(
                          initialValue: _phoneNo.replaceFirst('+', ''),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                          ],
                          autocorrect: false,
                          decoration: InputDecoration(
                              prefix: const Text('+'),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple)),
                              border: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple)),
                              icon: const Icon(
                                Icons.phone,
                                color: Colors.purple,
                              ),
                              hintText: _phoneNo.isEmpty
                                  ? '0123456789...'
                                  : _phoneNo.replaceFirst('+', ''),
                              labelText: 'Phone no',
                              labelStyle: const TextStyle(color: Colors.black)),
                          onChanged: (String value) {
                            _phoneNo = value.trim();
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Theme(
                        data: ThemeData(
                          primaryColor: Colors.purple,
                          primaryColorDark: Colors.purple,
                        ),
                        child: TypeAheadFormField(
                            validator: (value) {
                              var tempList = globals.states.where((element) =>
                                  element.keys.first
                                      .toLowerCase()
                                      .contains(value!.trim().toLowerCase()));

                              if (tempList.isEmpty) {
                                return 'State not found';
                              } else {
                                _stateController.text = value!
                                    .trim()
                                    .replaceFirst(
                                        value
                                            .trim()
                                            .substring(0, 1)
                                            .toUpperCase(),
                                        value.trim().substring(0, 1));
                              }
                            },
                            textFieldConfiguration: TextFieldConfiguration(
                                decoration: const InputDecoration(
                                    icon: Icon(Icons.map, color: Colors.purple),
                                    labelText: 'State',
                                    enabledBorder: UnderlineInputBorder(),
                                    border: UnderlineInputBorder(),
                                    focusedBorder: UnderlineInputBorder()),
                                controller: _stateController),
                            suggestionsCallback: (pattern) async {
                              if (pattern.isNotEmpty) {
                                return await OtherServices()
                                    .getStatePattern(pattern);
                              } else {
                                return [];
                              }
                            },
                            itemBuilder: (_, item) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  item.toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              );
                            },
                            onSuggestionSelected: (suggestion) {
                              setState(() {
                                _stateController.text = suggestion
                                    .toString()
                                    .replaceFirst(
                                        suggestion.toString().substring(0, 1),
                                        suggestion
                                            .toString()
                                            .substring(0, 1)
                                            .toUpperCase());
                              });
                            }),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Theme(
                        data: ThemeData(
                          primaryColor: Colors.purple,
                          primaryColorDark: Colors.purple,
                        ),
                        child: TypeAheadFormField(
                            validator: (value) {
                              var tempList = globals.states
                                  .where((element) => element.keys.first
                                      .toLowerCase()
                                      .contains(
                                          _stateController.text.toLowerCase()))
                                  .first
                                  .values
                                  .first
                                  .where((element) => element
                                      .toString()
                                      .toLowerCase()
                                      .contains(value!.trim().toLowerCase()));
                              if (tempList.isEmpty) {
                                return 'L.G.A not found';
                              } else {
                                _lgaController.text = value!
                                    .trim()
                                    .replaceFirst(
                                        value
                                            .trim()
                                            .substring(0, 1)
                                            .toUpperCase(),
                                        value.trim().substring(0, 1));
                              }
                            },
                            textFieldConfiguration: TextFieldConfiguration(
                                decoration: const InputDecoration(
                                    icon: Icon(Icons.map, color: Colors.purple),
                                    labelText: 'L.G.A',
                                    enabledBorder: UnderlineInputBorder(),
                                    border: UnderlineInputBorder(),
                                    focusedBorder: UnderlineInputBorder()),
                                controller: _lgaController),
                            suggestionsCallback: (pattern) async {
                              if (pattern.isNotEmpty) {
                                return await OtherServices().getLgaPattern(
                                    _stateController.text, pattern);
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
                                _lgaController.text = suggestion
                                    .toString()
                                    .replaceFirst(
                                        suggestion.toString().substring(0, 1),
                                        suggestion
                                            .toString()
                                            .substring(0, 1)
                                            .toUpperCase());
                              });
                            }),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            var _stateTemp = _stateController.text + '';
                            var _lgaTemp = _lgaController.text + '';
                            _stateTemp = _stateTemp.replaceFirst(
                                _stateTemp.substring(0, 1),
                                _stateTemp.substring(0, 1).toUpperCase());
                            _lgaTemp = _lgaTemp.replaceFirst(
                                _lgaTemp.substring(0, 1),
                                _lgaTemp.substring(0, 1).toUpperCase());
                            debugPrint(_stateTemp);

                            if (globals.states
                                .where((eachElement) =>
                                    eachElement.keys.first == _stateTemp &&
                                    eachElement.values.first.contains(_lgaTemp))
                                .isEmpty) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        content: Text(
                                          _stateTemp +
                                              ' has no LGA named ' +
                                              _lgaTemp +
                                              '\nPlease make sure state and LGA do match.',
                                          overflow: TextOverflow.clip,
                                        ),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Ok'))
                                        ],
                                      ));
                              setState(() {
                                _isLoading = false;
                              });
                              return;
                            }
                            try {
                              var token =
                                  await FirebaseMessaging.instance.getToken();
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser!.email)
                                  .set({
                                'isVendor': false,
                                'email':
                                    FirebaseAuth.instance.currentUser!.email,
                                'phone': _phoneNo,
                                'state': _stateTemp,
                                'lga': _lgaTemp,
                                'token': token,
                                'name': _displayName,
                              });
                              setState(() {
                                _isLoading = false;
                                _isShowingSuccessMessage = true;
                              });
                              Timer(const Duration(seconds: 3), () {
                                setState(() {
                                  _isShowingSuccessMessage = false;
                                });
                              });
                            } on FirebaseException catch (e) {
                              setState(() {
                                _isLoading = false;
                                _addressErrorText = e.code;
                              });
                            }
                          },
                          child: const Text(
                            'Update Details',
                            style: TextStyle(fontSize: 18),
                          )),
                      _addressErrorText.isEmpty
                          ? const SizedBox()
                          : SizedBox(
                              height: 20,
                              child: Text(
                                _addressErrorText,
                                style: const TextStyle(
                                    fontSize: 17, color: Colors.red),
                              )),
                    ],
                  ),
                ),
              ],
            ),
            _isShowingSuccessMessage
                ? const ShowSuccessAlert()
                : const SizedBox(),
            _isLoading
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white.withOpacity(0.5),
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      color: Colors.purple,
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
