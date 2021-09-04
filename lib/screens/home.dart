import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meraketme/services/OtherServices.dart';
import 'package:meraketme/widgets/food_view.dart';
import 'package:meraketme/screens/shopping_cart.dart';

import '../widgets/drawerClass.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final payload;

  const Home({Key? key, this.payload}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map> _foodList = [];
  bool _hasWidgetBuilt = false;
  Position? _position;
  bool _isLoading = false;
  final List _states = [
    'Abia',
    'Adamawa',
    'Akwa Ibom',
    'Anambra',
    'Bauchi',
    'Bayelsa',
    'Benue',
    'Borno',
    'CrosRiver',
    'Delta',
    'Ebonyi',
    'Edo',
    'Ekit',
    'Enugu',
    'Gombe',
    'Imo',
    'Jigawa',
    'Kaduna',
    'Kano',
    'Katsina',
    'Kebbi',
    'Kogi',
    'Kwara',
    'Lagos',
    'Nasarawa',
    'Niger',
    'Ogun',
    'Osun',
    'Ondo',
    'Osun',
    'Oyo',
    'Plateau',
    'Rivers',
    'Sokoto',
    'Taraba',
    'Yobe',
    'Zamfara'
  ];
  final List<String> _categories = [
    'Appetizers',
    'Desserts',
    'Local',
    'Beverage',
    'Pasta',
    'Sandwiches'
  ];
  bool _emptyVendorsInState = false;
  String _selectedCategory = 'All Categories';
  String _selectedState = 'Lagos';

  Future _updateFoodList() async {
    try {
      setState(() {
        _isLoading = true;
        _emptyVendorsInState = false;
      });

      var _docs = await FirebaseFirestore.instance
          .collection('users')
          .where('isVendor', isEqualTo: true)
          .where('location', isEqualTo: _selectedState)
          .get();

      var _vendorList = _docs.docs.map((e) => {'data': e.data()}).toList();

      for (int i = 0; i < _vendorList.length; i++) {
        GeoPoint g = _vendorList[i]['data']!['latlng'];
        var distance = Geolocator.distanceBetween(_position!.latitude,
                _position!.longitude, g.latitude, g.longitude) /
            1000;
        //don't forget to change back the logical operators
        if (distance >=
            double.parse(_vendorList[i]['data']!['highestDistance'])) {
          _vendorList[i]['data']!['shouldShow'] = true;
        } else {
          _vendorList[i]['data']!['shouldShow'] = false;
        }
      }
      if (_vendorList.isNotEmpty) {
        _docs = await FirebaseFirestore.instance
            .collection('foods')
            .where('vendor',
                whereIn: _vendorList
                    .where((element) => element['data']!['shouldShow'] == true)
                    .toList()
                    .map((e) => e['data']!['email'])
                    .toList())
            .get();

        _foodList = _docs.docs
            .map((element) => {'data': element.data(), 'id': element.id})
            .toList();

        for (int i = 0; i < _foodList.length; i++) {
          _foodList[i]['data']['location'] = _vendorList
              .where((element) =>
                  element['data']!['email'] == _foodList[i]['data']['vendor'])
              .first['data']!['location'];
        }
        setState(() {
          for (int i = 0; i < 6; i++) {
            _foodList.add(_foodList.first);
            _foodList.add(_foodList[1]);
          }
          if (_foodList.isEmpty) _emptyVendorsInState = true;
        });
      } else {
        _foodList.clear();
      }
    } on FirebaseException catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text(
                  'Oops',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                content: Text(
                  e.code.toString(),
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ));
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future _getFoodList() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationServiceEnabled == false) {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        LocationPermission _permission2 = await Geolocator.requestPermission();
        if (_permission2 == LocationPermission.denied ||
            _permission2 == LocationPermission.deniedForever) {
          await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        await showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text('Oh oh!'),
                  content: const Text('You need to allow location permissions'),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Quit'))
                  ],
                ));
        await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      }
    }

    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    await _updateFoodList();
  }

  @override
  void initState() {
    super.initState();
    _getFoodList();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'MerakEtme',
          style: GoogleFonts.encodeSans(fontSize: 20),
        ),
      ),
      body: Container(
          color: Colors.grey[200],
          height: _height,
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          TypeAheadField(
                            suggestionsCallback: (pattern) async {
                              if (pattern.isNotEmpty) {
                                return await OtherServices().getSearchPattern(
                                    pattern,
                                    _selectedState,
                                    _selectedCategory,
                                    _foodList);
                              } else {
                                return [];
                              }
                            },
                            itemBuilder: (_, item) {
                              var itemName = item as Map;
                              return ListTile(
                                title: Text(item['data']['name'].toString()),
                              );
                            },
                            onSuggestionSelected: (suggestion) {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (BuildContext context) => Wrap(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                const ShoppingCart()));
                                                  },
                                                  icon: const Icon(
                                                    Icons
                                                        .shopping_cart_outlined,
                                                    color: Colors.purple,
                                                    size: 30,
                                                  )),
                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  icon: const Icon(
                                                    Icons.cancel_outlined,
                                                    color: Colors.purple,
                                                    size: 30,
                                                  ))
                                            ],
                                          ),
                                          Food_view(selectedFood: suggestion)
                                        ],
                                      ));
                            },
                            textFieldConfiguration:
                                const TextFieldConfiguration(
                              autofocus: false,
                              decoration: InputDecoration(
                                  icon: Icon(Icons.search),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.purple)),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.purple)),
                                  border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.purple)),
                                  hintText: 'Cheese burger',
                                  labelText: 'Search for your favorite food?',
                                  labelStyle: TextStyle(color: Colors.black)),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Row(
                            children: [
                              const Text('Categories: '),
                              DropdownButton(
                                iconEnabledColor: Colors.purple,
                                value: _selectedCategory,
                                hint: const Text('Desserts'),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCategory = value.toString();
                                  });
                                },
                                items: [
                                  const DropdownMenuItem(
                                      value: 'All Categories',
                                      child: Text('All Categories')),
                                  ...(_categories
                                      .map((e) => DropdownMenuItem(
                                          value: e, child: Text(e)))
                                      .toList())
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              const Text('Location: '),
                              DropdownButton(
                                iconEnabledColor: Colors.purple,
                                value: _selectedState,
                                hint: const Text('Lagos'),
                                onChanged: (value) async {
                                  setState(() {
                                    _selectedState = value.toString();
                                  });
                                  await _updateFoodList();
                                },
                                items: [
                                  ...(_states
                                      .map((e) => DropdownMenuItem(
                                          value: e, child: Text(e)))
                                      .toList())
                                ],
                              )
                            ],
                          )
                        ],
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  Flexible(
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.all(4.0),
                        child: _emptyVendorsInState
                            ? const Center(
                                child: Text(
                                    'No Restaurant or vendor found close by'),
                              )
                            : _foodList.isNotEmpty
                                ? _foodList
                                            .where((element) =>
                                                element['data']['category'] ==
                                                _selectedCategory)
                                            .toList()
                                            .isEmpty &&
                                        _selectedCategory != 'All Categories'
                                    ? const Center(
                                        child: Text(
                                          'No items to display for this category',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )
                                    : Scrollbar(
                                        thickness: 5,
                                        child: GridView.builder(
                                            itemCount: _selectedCategory !=
                                                    "All Categories"
                                                ? _foodList
                                                    .where((element) =>
                                                        element['data']
                                                            ['category'] ==
                                                        _selectedCategory)
                                                    .toList()
                                                    .length
                                                : _foodList.length,
                                            shrinkWrap: true,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    crossAxisSpacing: 10,
                                                    mainAxisSpacing: 5),
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                        isScrollControlled:
                                                            true,
                                                        context: context,
                                                        builder:
                                                            (BuildContext
                                                                    context) =>
                                                                Wrap(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => const ShoppingCart()));
                                                                            },
                                                                            icon:
                                                                                const Icon(
                                                                              Icons.shopping_cart_outlined,
                                                                              color: Colors.purple,
                                                                              size: 30,
                                                                            )),
                                                                        IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            icon:
                                                                                const Icon(
                                                                              Icons.cancel_outlined,
                                                                              color: Colors.purple,
                                                                              size: 30,
                                                                            ))
                                                                      ],
                                                                    ),
                                                                    Food_view(
                                                                        selectedFood: _selectedCategory !=
                                                                                "All Categories"
                                                                            ? _foodList.where((element) => element['data']['category'] == _selectedCategory).toList()[index]
                                                                            : _foodList[index])
                                                                  ],
                                                                ));
                                                  },
                                                  child: Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                    child: Stack(
                                                      children: [
                                                        CachedNetworkImage(
                                                          imageUrl: _selectedCategory !=
                                                                  "All Categories"
                                                              ? _foodList
                                                                      .where((element) =>
                                                                          element['data']
                                                                              [
                                                                              'category'] ==
                                                                          _selectedCategory)
                                                                      .toList()[index]['data']
                                                                  ['picture']
                                                              : _foodList[index]
                                                                      ['data']
                                                                  ['picture'],
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                onError: (error,
                                                                    stack) {
                                                                  debugPrint(error
                                                                      .toString());
                                                                },
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                            ),
                                                          ),
                                                          placeholder:
                                                              (context, url) {
                                                            return const Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            );
                                                          },
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(
                                                                  Icons.error),
                                                        ),
                                                        Align(
                                                            alignment: Alignment
                                                                .bottomCenter,
                                                            child: Container(
                                                                height: 40,
                                                                width: double
                                                                    .infinity,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                margin:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        10),
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      (_selectedCategory !=
                                                                              "All Categories")
                                                                          ? _foodList.where((element) => element['data']['category'] == _selectedCategory).toList()[index]['data']
                                                                              [
                                                                              'name']
                                                                          : _foodList[index]['data']
                                                                              [
                                                                              'name'],
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              18),
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                    ),
                                                                    _selectedCategory !=
                                                                            "All Categories"
                                                                        ? Text('By ' +
                                                                            _foodList.where((element) => element['data']['category'] == _selectedCategory).toList()[index]['data']['restaurant'])
                                                                        : Text(
                                                                            'By ' +
                                                                                _foodList[index]['data']['restaurant'],
                                                                          )
                                                                  ],
                                                                ))),
                                                        Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            decoration:
                                                                const BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            child: _selectedCategory !=
                                                                    "All Categories"
                                                                ? Text('N' + _foodList.where((element) => element['data']['category'] == _selectedCategory).toList()[index]['data']['price'],
                                                                    style: const TextStyle(
                                                                        fontWeight: FontWeight
                                                                            .bold,
                                                                        fontStyle: FontStyle
                                                                            .italic,
                                                                        fontSize:
                                                                            16))
                                                                : Text(
                                                                    'N' +
                                                                        _foodList[index]['data'][
                                                                            'price'],
                                                                    style: const TextStyle(
                                                                        fontWeight: FontWeight
                                                                            .bold,
                                                                        fontStyle:
                                                                            FontStyle.italic,
                                                                        fontSize: 16)),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ));
                                            }),
                                      )
                                : const SizedBox()),
                  ),
                  // SizedBox(
                  //   height: 80,
                  //   child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //       children: [
                  //         const Text('Support Service'),
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //           children: [
                  //             GestureDetector(
                  //               child: Image.asset(
                  //                 'assets/images/facebook.png',
                  //                 height: 30,
                  //                 width: 30,
                  //               ),
                  //             ),
                  //             GestureDetector(
                  //               child: Image.asset(
                  //                 'assets/images/whatsapp.png',
                  //                 height: 35,
                  //                 width: 35,
                  //               ),
                  //             ),
                  //             GestureDetector(
                  //               child: Image.asset(
                  //                 'assets/images/instagram.png',
                  //                 height: 30,
                  //                 width: 30,
                  //               ),
                  //             )
                  //           ],
                  //         )
                  //       ]),
                  // ),
                  const SizedBox(height: 15)
                ],
              ),
              _isLoading
                  ? Container(
                      color: Colors.white.withOpacity(0.5),
                      height: _height,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        color: Colors.purple,
                      ),
                    )
                  : const SizedBox()
            ],
          )),
      drawer: const DrawerClass(),
    );
  }
}
