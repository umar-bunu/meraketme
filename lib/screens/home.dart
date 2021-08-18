import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
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

  String _selectedCategory = 'All Categories';
  String _selectedState = 'Lagos';

  Future _getFoodList() async {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_hasWidgetBuilt) {
        bool isLocationServiceEnabled =
            await Geolocator.isLocationServiceEnabled();
        if (isLocationServiceEnabled == false) {
          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            LocationPermission _permission2 =
                await Geolocator.requestPermission();
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
                      content:
                          const Text('You need to allow location permissions'),
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

        timer.cancel();
      }
    });
    try {
      var _position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      var _docs = await FirebaseFirestore.instance
          .collection('users')
          .where('isVendor', isEqualTo: true)
          .where('location', isEqualTo: _selectedState)
          .get();
      var _vendorList = _docs.docs.map((e) => {'data': e.data()}).toList();
      for (int i = 0; i < _vendorList.length; i++) {
        var distance = Geolocator.distanceBetween(
                _position.latitude,
                _position.longitude,
                double.parse(
                    _vendorList[i]['data']!['latlng']['latitude'].toString()),
                double.parse(_vendorList[i]['data']!['latlng']['longitude']
                    .toString())) /
            1000;
        if (distance <=
            double.parse(_vendorList[i]['data']!['highestdistance'])) {
          _vendorList[i]['data']!['shouldShow'] = true;
        } else {
          _vendorList[i]['data']!['shouldShow'] = false;
        }
      }
      _docs = await FirebaseFirestore.instance
          .collection('foods')
          .where('vendor',
              whereIn: _vendorList
                  .where((element) => element['data']!['shouldShow'] == true)
                  .toList()
                  .map((e) => e['data']!['vendor'])
                  .toList())
          .get();

      _foodList = _docs.docs
          .map((element) => {'data': element.data(), 'id': element.id})
          .toList();

      for (int i = 0; i < _foodList.length; i++) {}
      setState(() {
        for (int i = 0; i < 6; i++) {
          _foodList.add(_foodList.first);
          _foodList.add(_foodList[1]);
        }
      });
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
    _hasWidgetBuilt = true;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          color: Colors.grey[200],
          height: _height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                height: 15,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      const TextField(
                        decoration: InputDecoration(
                            icon: Icon(Icons.search),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple)),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.purple)),
                            hintText: 'Cheese burger',
                            labelText: 'Search for your favorite food?',
                            labelStyle: TextStyle(color: Colors.black)),
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
                    child: _foodList.isNotEmpty
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
                                                element['data']['category'] ==
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
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                                isScrollControlled: true,
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        Wrap(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              8.0),
                                                                  child: Icon(
                                                                    Icons
                                                                        .favorite,
                                                                    color: Colors
                                                                        .purple,
                                                                  ),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pushReplacement(
                                                                              context,
                                                                              MaterialPageRoute(builder: (BuildContext context) => const ShoppingCart()));
                                                                        },
                                                                        icon:
                                                                            const Icon(
                                                                          Icons
                                                                              .shopping_cart_outlined,
                                                                          color:
                                                                              Colors.purple,
                                                                          size:
                                                                              30,
                                                                        )),
                                                                    IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        icon:
                                                                            const Icon(
                                                                          Icons
                                                                              .cancel_outlined,
                                                                          color:
                                                                              Colors.purple,
                                                                          size:
                                                                              30,
                                                                        ))
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            Food_view(
                                                                selectedFood: _selectedCategory !=
                                                                        "All Categories"
                                                                    ? _foodList
                                                                        .where((element) =>
                                                                            element['data']['category'] ==
                                                                            _selectedCategory)
                                                                        .toList()[index]
                                                                    : _foodList[index])
                                                          ],
                                                        ));
                                          },
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
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
                                                              .toList()[index]
                                                          ['data']['picture']
                                                      : _foodList[index]['data']
                                                          ['picture'],
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        onError:
                                                            (error, stack) {
                                                          debugPrint(
                                                              error.toString());
                                                        },
                                                        image: imageProvider,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  },
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
                                                Align(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    child: Container(
                                                        height: 40,
                                                        width: double.infinity,
                                                        alignment:
                                                            Alignment.center,
                                                        margin: const EdgeInsets
                                                            .all(10),
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              (_selectedCategory !=
                                                                      "All Categories")
                                                                  ? _foodList
                                                                          .where((element) =>
                                                                              element['data']['category'] ==
                                                                              _selectedCategory)
                                                                          .toList()[index]['data']
                                                                      ['name']
                                                                  : _foodList[index]
                                                                          [
                                                                          'data']
                                                                      ['name'],
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          18),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                            _selectedCategory !=
                                                                    "All Categories"
                                                                ? Text('By ' +
                                                                    _foodList
                                                                        .where((element) =>
                                                                            element['data']['category'] ==
                                                                            _selectedCategory)
                                                                        .toList()[index]['data']['restaurant'])
                                                                : Text(
                                                                    'By ' +
                                                                        _foodList[index]['data']
                                                                            [
                                                                            'restaurant'],
                                                                  )
                                                          ],
                                                        ))),
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.white,
                                                    ),
                                                    child: _selectedCategory !=
                                                            "All Categories"
                                                        ? Text('N' + _foodList.where((element) => element['data']['category'] == _selectedCategory).toList()[index]['data']['price'],
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                fontSize: 16))
                                                        : Text(
                                                            'N' +
                                                                _foodList[index]
                                                                        ['data']
                                                                    ['price'],
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
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
                        : const Center(child: CircularProgressIndicator())),
              ),
              SizedBox(
                height: 80,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text('Support Service'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            child: Image.asset(
                              'assets/images/facebook.png',
                              height: 20,
                              width: 20,
                            ),
                          ),
                          GestureDetector(
                            child: Image.asset(
                              'assets/images/whatsapp.png',
                              height: 25,
                              width: 25,
                            ),
                          ),
                          GestureDetector(
                            child: Image.asset(
                              'assets/images/instagram.png',
                              height: 20,
                              width: 20,
                            ),
                          )
                        ],
                      )
                    ]),
              )
            ],
          ),
        ),
      ),
      drawer: const DrawerClass(),
    );
  }
}
