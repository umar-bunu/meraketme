// ignore_for_file: file_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:meraketme/services/FireStoreServices.dart';
import 'package:meraketme/widgets/showSuccessAlert.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

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
  String _doorNumApt = '';
  String _street = '';
  String _state = '';
  String _phoneNo = '';

  String _phoneDocId = '';
  String _addressDocId = '';

  String _errorText = '';
  String _phoneErrorText = '';
  String _addressErrorText = '';

  Future _getDetails() async {
    try {
      List _docs = await FireStoreServices()
          .getShippingDetails(FirebaseAuth.instance.currentUser!.email);
      setState(() {
        _addressDocId = _docs.first['id'];
        _doorNumApt = _docs.first['data']['doorNumApt'];
        _street = _docs.first['data']['street'];
        _state = _docs.first['data']['state'];
      });
      var _query = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
          .get();
      _phoneDocId = _query.docs.first.id;

      setState(() {
        _phoneNo = _query.docs.first.data()['phone'];
      });
    } on FirebaseException catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('Ooops'),
                content: Text(e.code + '\n Please try again Later'),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Ok'))
                ],
              ));
    }
  }

  @override
  void initState() {
    super.initState();
    _getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
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
                          child: const Text(
                            'Update Password',
                            style: TextStyle(fontSize: 16),
                          )),
                      const SizedBox(height: 15),
                      const Center(
                        child: Text(
                          'Phone number',
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
                      _phoneErrorText.isEmpty
                          ? const SizedBox()
                          : SizedBox(
                              height: 20,
                              child: Text(
                                _phoneErrorText,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.red),
                              ),
                            ),
                      ElevatedButton(
                          onPressed: () async {
                            if (_isLoading) {
                              return;
                            }

                            if (_phoneNo.isEmpty) {
                              setState(() {
                                _phoneErrorText =
                                    'Invalid phone. Please make sure to put a valid phone as this will be used by the vendor to contact you';
                              });
                              return;
                            }

                            setState(() {
                              _phoneErrorText = '';
                              _isLoading = true;
                            });
                            try {
                              if (_phoneDocId.isEmpty) {
                                var _query = await FirebaseFirestore.instance
                                    .collection('users')
                                    .where('email',
                                        isEqualTo: FirebaseAuth
                                            .instance.currentUser!.email)
                                    .get();
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(_query.docs.first.id)
                                    .set({
                                  'isVendor': false,
                                  'email':
                                      FirebaseAuth.instance.currentUser!.email,
                                  'phone': '+' + _phoneNo
                                });
                              } else {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(_phoneDocId)
                                    .set({
                                  'isVendor': false,
                                  'email':
                                      FirebaseAuth.instance.currentUser!.email,
                                  'phone': '+' + _phoneNo
                                });
                              }
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
                                _phoneErrorText = e.code;
                                _isLoading = false;
                              });
                            }
                          },
                          child: const Text(
                            'Update Phone',
                            style: TextStyle(fontSize: 17),
                          ))
                    ],
                  ),
                ),
                Form(
                  key: _shippingFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      const Center(
                          child: Text(
                        'Shipping details',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      )),
                      Theme(
                        data: ThemeData(
                          primaryColor: Colors.purple,
                          primaryColorDark: Colors.purple,
                        ),
                        child: TextFormField(
                          autocorrect: false,
                          decoration: InputDecoration(
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple)),
                              border: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple)),
                              icon: const Icon(
                                Icons.lock_rounded,
                                color: Colors.purple,
                              ),
                              hintText: _doorNumApt.isEmpty
                                  ? 'DoorNo, Apt Name (leave blank if none)'
                                  : _doorNumApt,
                              labelText: 'House address',
                              labelStyle: const TextStyle(color: Colors.black)),
                          onChanged: (String value) {
                            _doorNumApt = value.trim();
                          },
                          validator: (String? value) {},
                        ),
                      ),
                      Theme(
                        data: ThemeData(
                          primaryColor: Colors.purple,
                          primaryColorDark: Colors.purple,
                        ),
                        child: TextFormField(
                          autocorrect: false,
                          decoration: InputDecoration(
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple)),
                              border: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple)),
                              icon: const Icon(
                                Icons.lock_rounded,
                                color: Colors.purple,
                              ),
                              hintText: _street.isNotEmpty
                                  ? _street
                                  : 'Goodluck Ebele Road, F. lowcost',
                              labelText: 'Street name',
                              labelStyle: const TextStyle(color: Colors.black)),
                          onChanged: (String value) {
                            _street = value.trim();
                          },
                          validator: (String? value) {
                            if (value!.trim().isEmpty) {
                              return 'Field is required';
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
                          autocorrect: false,
                          decoration: InputDecoration(
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple)),
                              border: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.purple)),
                              icon: const Icon(
                                Icons.lock_rounded,
                                color: Colors.purple,
                              ),
                              hintText: _state.isEmpty ? 'Gombe State' : _state,
                              labelText: 'State/City',
                              labelStyle: const TextStyle(color: Colors.black)),
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
                      const SizedBox(
                        height: 15,
                      ),
                      _addressErrorText.isEmpty
                          ? const SizedBox()
                          : SizedBox(
                              height: 20,
                              child: Text(
                                _addressErrorText,
                                style: const TextStyle(
                                    fontSize: 17, color: Colors.red),
                              )),
                      ElevatedButton(
                          onPressed: () async {
                            if (_state.isEmpty ||
                                _doorNumApt.isEmpty ||
                                _street.isEmpty) {
                              setState(() {
                                _addressErrorText =
                                    'Invalid address to send, all adress fields must be filled.';
                              });
                              return;
                            }
                            setState(() {
                              _addressErrorText = '';
                              _isLoading = true;
                            });
                            try {
                              await FirebaseFirestore.instance
                                  .collection('shippingDetails')
                                  .doc(_addressDocId)
                                  .set({
                                'email':
                                    FirebaseAuth.instance.currentUser!.email,
                                'doorNumApt': _doorNumApt,
                                'state': _state,
                                'street': _street
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
                                _addressErrorText = e.code;
                                _isLoading = false;
                              });
                            }
                          },
                          child: const Text(
                            'Update Address',
                            style: TextStyle(fontSize: 18),
                          ))
                    ],
                  ),
                )
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
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
