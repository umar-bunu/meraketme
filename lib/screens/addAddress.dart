// ignore_for_file: file_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meraketme/widgets/showSuccessAlert.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({Key? key}) : super(key: key);

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  GeoPoint _latlng = GeoPoint(9.072264, 7.491302);
  Completer<GoogleMapController> _contoller = Completer();
  Set<Marker> _markers = {};
  String? _aptName;
  String? _aptNum;
  String? _doorNum;
  int? _floor;
  String? _street;

  bool _isShowingConfirmInfo = false;
  bool _isLoadingUpdate = false;
  bool _isShowingSuccessAlert = false;
  bool _shouldShowInfo = true;
  @override
  void initState() {
    _setMarkers();
    super.initState();
  }

  Future _setMarkers() async {
    Marker _temMarker = Marker(
        infoWindow: const InfoWindow(title: 'Your location'),
        onDragEnd: (newPosition) {
          setState(() {
            _markers = {_markers.first.copyWith(positionParam: newPosition)};
          });
        },
        draggable: true,
        icon: await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), 'assets/images/userIconMarker.png'),
        markerId: const MarkerId('userLocation'),
        position: LatLng(_latlng.latitude, _latlng.longitude));
    setState(() {
      _markers.add(_temMarker);
    });
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
                'Add Location',
                style: TextStyle(fontSize: 22),
              ),
            ),
      body: Stack(
        children: [
          GoogleMap(
              onMapCreated: (controller) {
                _contoller.complete(controller);
                _getLocationData();
              },
              markers: _markers,
              initialCameraPosition: CameraPosition(
                  target: LatLng(_latlng.latitude, _latlng.longitude),
                  zoom: 7)),
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
                              initialValue: '',
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
                                            '/locations')
                                        .add({
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
                                  'Submit',
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
          _isShowingSuccessAlert ? const ShowSuccessAlert() : const SizedBox(),
          _shouldShowInfo
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 40.0, bottom: 8.0, left: 8, right: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Drag the red marker to your address destination on the map',
                              style: TextStyle(
                                  overflow: TextOverflow.clip, fontSize: 18),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _shouldShowInfo = false;
                                    });
                                  },
                                  child: const Text('Got it')),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }

  Future _getLocationData() async {
    try {
      Position _position = await Geolocator.getCurrentPosition();
      setState(() {
        _latlng = GeoPoint(_position.latitude, _position.longitude);
        _markers = {
          _markers.first.copyWith(
              positionParam: LatLng(_position.latitude, _position.longitude))
        };
      });
      var contoller = await _contoller.future;
      contoller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(
            _position.latitude,
            _position.longitude,
          ),
          zoom: 14)));
    } catch (e) {
      debugPrint(e.toString());
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('OOps'),
                content: const Text(
                  'Could Not get your current location.\n You can select your location manually',
                  overflow: TextOverflow.clip,
                ),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Okay'))
                ],
              ));
    }
  }
}
