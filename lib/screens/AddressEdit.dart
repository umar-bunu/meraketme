// ignore_for_file: file_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meraketme/widgets/showSuccessAlert.dart';

class AddressEdit extends StatefulWidget {
  var addRessData;
  AddressEdit({Key? key, this.addRessData}) : super(key: key);

  @override
  _AddressEditState createState() => _AddressEditState();
}

class _AddressEditState extends State<AddressEdit> {
  GeoPoint? _latlng;
  Set<Marker> _markers = {};
  String? _aptName;
  String? _aptNum;
  String? _doorNum;
  int? _floor;
  String? _street;
  bool _isJustEnteredPage = true;
  bool _isShowingConfirmInfo = false;
  bool _isLoadingUpdate = false;
  bool _isShowingSuccessAlert = false;
  @override
  void initState() {
    setState(() {
      _latlng = widget.addRessData['data']['latlng'];
      _aptName = widget.addRessData['data']['aptName'];
      _aptNum = widget.addRessData['data']['aptNum'];
      _doorNum = widget.addRessData['data']['doorNum'];
      _street = widget.addRessData['data']['street'];
      _floor = widget.addRessData['data']['floor'];
      _markers.add(Marker(
          infoWindow: const InfoWindow(title: 'Your location'),
          onDragEnd: (newPosition) {
            setState(() {
              _markers = {_markers.first.copyWith(positionParam: newPosition)};
            });
          },
          draggable: true,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
          markerId: const MarkerId('userLocation'),
          position: LatLng(_latlng!.latitude, _latlng!.longitude)));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _isShowingConfirmInfo
            ? const SizedBox()
            : ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isShowingConfirmInfo = true;
                  });
                  debugPrint(_markers.first.position.toString());
                },
                child: const Text(
                  'Update Location',
                  style: TextStyle(fontSize: 22),
                ),
              ),
        body: Stack(
          children: [
            GoogleMap(
                markers: _markers,
                initialCameraPosition: CameraPosition(
                    target: LatLng(_latlng!.latitude, _latlng!.longitude),
                    zoom: 18)),
            SafeArea(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: const EdgeInsets.only(left: 20, bottom: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white),
                          child: const Icon(
                            Icons.navigate_before_outlined,
                            color: Colors.purple,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _isShowingConfirmInfo
                ? Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              'Confirm Your Details',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 17, overflow: TextOverflow.clip),
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
                                initialValue: _aptNum,
                                onChanged: (value) {
                                  _aptNum = value.trim();
                                },
                                decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Apart No: '),
                              ),
                            ),
                            Theme(
                              data: ThemeData(
                                primaryColor: Colors.purple,
                                primaryColorDark: Colors.purple,
                              ),
                              child: TextFormField(
                                initialValue: _aptName,
                                onChanged: (value) {
                                  _aptName = value.trim();
                                },
                                decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Apart Name: '),
                              ),
                            ),
                            Theme(
                              data: ThemeData(
                                primaryColor: Colors.purple,
                                primaryColorDark: Colors.purple,
                              ),
                              child: TextFormField(
                                initialValue: _doorNum,
                                onChanged: (value) {
                                  _doorNum = value.trim();
                                },
                                decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Apart no: '),
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
                                      RegExp(r'[0-9]')),
                                ],
                                initialValue: _floor.toString(),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  _floor = int.parse(value.trim());
                                },
                                decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Floor no: '),
                              ),
                            ),
                            Theme(
                              data: ThemeData(
                                primaryColor: Colors.purple,
                                primaryColorDark: Colors.purple,
                              ),
                              child: TextFormField(
                                initialValue: _street,
                                onChanged: (value) {
                                  _street = value.trim();
                                },
                                decoration: const InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Street: '),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_isLoadingUpdate) return;

                                    setState(() {
                                      _isLoadingUpdate = true;
                                    });
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection('shippingDetails/' +
                                              FirebaseAuth
                                                  .instance.currentUser!.email
                                                  .toString() +
                                              '/locations/')
                                          .doc(widget.addRessData['id'])
                                          .update({
                                        'aptName': _aptName,
                                        'aptNum': _aptNum,
                                        'doorNum': _doorNum,
                                        'floor': _floor,
                                        'latlng': GeoPoint(
                                            _markers.first.position.latitude,
                                            _markers.first.position.longitude),
                                        'street': _street
                                      });
                                      setState(() {
                                        _isLoadingUpdate = false;
                                        _isShowingConfirmInfo = false;
                                        _isShowingSuccessAlert = true;
                                      });
                                      Timer(const Duration(seconds: 3), () {
                                        setState(() {
                                          _isShowingSuccessAlert = false;
                                        });
                                      });
                                    } on FirebaseException catch (e) {
                                      setState(() {
                                        _isLoadingUpdate = false;
                                      });
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: const Text('Oh oh!'),
                                                content: Text(e.toString()),
                                                actions: [
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text('Okay'))
                                                ],
                                              ));
                                    }
                                    debugPrint(
                                        _markers.first.position.toString());
                                  },
                                  child: const Text(
                                    'Update',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) => Colors.red)),
                                  onPressed: () {
                                    setState(() {
                                      _isShowingConfirmInfo = false;
                                    });
                                    debugPrint(
                                        _markers.first.position.toString());
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            )
                          ],
                        ),
                      ),
                    ))
                : const SizedBox(),
            _isLoadingUpdate
                ? Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white.withOpacity(0.3),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          CircularProgressIndicator(),
                          Text('Loading...')
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
            _isShowingSuccessAlert ? const ShowSuccessAlert() : const SizedBox()
          ],
        ));
  }
}
