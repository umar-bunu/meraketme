import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:meraketme/widgets/food_view.dart';
import 'package:meraketme/screens/shopping_cart.dart';

import '../widgets/drawerClass.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map> _foodList = [];
  Future _getFoodList() async {
    try {
      var _docs = await FirebaseFirestore.instance.collection('foods').get();

      _foodList = _docs.docs
          .map((element) => {'data': element.data(), 'id': element.id})
          .toList();
      setState(() {
        for (int i = 0; i < 14; i++) {
          _foodList.add(_foodList.first);
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

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.grey[200],
        height: _height,
        child: SafeArea(
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              const SizedBox(
                height: 15,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
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
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: _height * 0.65,
                width: _width,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.all(4.0),
                  child: Scrollbar(
                    thickness: 5,
                    child: GridView.builder(
                        itemCount: _foodList.length,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 5),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (BuildContext context) => Wrap(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    Icons.favorite,
                                                    color: Colors.black,
                                                  ),
                                                ),
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
                                                          Icons.shopping_cart,
                                                          size: 30,
                                                        )),
                                                    IconButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        icon: const Icon(
                                                          Icons.cancel,
                                                          color: Colors.black,
                                                          size: 30,
                                                        ))
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Food_view(
                                                selectedFood: _foodList[index])
                                          ],
                                        ));
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Stack(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Image.network(
                                        _foodList[index]['data']['picture'],
                                      ),
                                    ),
                                    Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                            height: 40,
                                            width: double.infinity,
                                            alignment: Alignment.center,
                                            margin: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Column(
                                              children: [
                                                Text(
                                                  _foodList[index]['data']
                                                      ['name'],
                                                  style: const TextStyle(
                                                      fontSize: 18),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  'By ' +
                                                      _foodList[index]['data']
                                                          ['restaurant'],
                                                )
                                              ],
                                            ))),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Text(
                                            'N' +
                                                _foodList[index]['data']
                                                    ['price'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 16)),
                                      ),
                                    )
                                  ],
                                ),
                              ));
                        }),
                  ),
                ),
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text('Support Service'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          child: Image.asset(
                            'assets/images/facebook.png',
                            height: 30,
                            width: 30,
                          ),
                        ),
                        GestureDetector(
                          child: Image.asset(
                            'assets/images/whatsapp.png',
                            height: 40,
                            width: 40,
                          ),
                        ),
                        GestureDetector(
                          child: Image.asset(
                            'assets/images/instagram.png',
                            height: 30,
                            width: 30,
                          ),
                        ),
                        GestureDetector(
                          child: Image.asset(
                            'assets/images/instagram.png',
                            height: 30,
                            width: 30,
                          ),
                        )
                      ],
                    )
                  ])
            ],
          ),
        ),
      ),
      drawer: const DrawerClass(),
    );
  }
}
