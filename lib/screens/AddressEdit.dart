// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressEdit extends StatefulWidget {
  var addRessData;
  AddressEdit({Key? key, required this.addRessData}) : super(key: key);

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

  @override
  void initState() {
    setState(() {
      _latlng = widget.addRessData['data']['latlng'];
      _aptName = widget.addRessData['data']['aptName'];
      _aptNum = widget.addRessData['data']['aptNum'];
      _doorNum = widget.addRessData['data']['doorNum'];
      _street = widget.addRessData['data']['street'];
      _markers.add(Marker(
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
        floatingActionButton: ElevatedButton(
          onPressed: () {
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
          ],
        ));
  }
}
