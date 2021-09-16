import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meraketme/screens/Profile.dart';
import 'package:meraketme/screens/RestaurantView.dart';
import 'package:meraketme/services/FireStoreServices.dart';
import 'package:meraketme/widgets/food_view.dart';

class Home extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final payload;
  var userData;

  Home({Key? key, this.payload, this.userData}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _restaurantList = [];
  List _foodList = [];
  List _foodListByPromos = [];
  Future _getUserData() async {
    var docs = await FireStoreServices().getRestaurantsByPopular(
        widget.userData['data']['state'], widget.userData['data']['lga']);
    if (docs.isNotEmpty) _foodListByPromos = List.from(docs['foods']);
    if (docs.isNotEmpty) _restaurantList = List.from(docs['restaurants']);
    setState(() {
      _restaurantList
          .sort((a, b) => b['data']['hits'].compareTo(a['data']['hits']));
      _foodListByPromos.sort((a, b) => double.parse(b['data']['discount'])
          .compareTo(double.parse(a['data']['discount'])));
      for (var element in _foodListByPromos) {
        debugPrint(element['data']['discount']);
      }
      _foodList = docs['foods'];
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'merakEtme',
          style: GoogleFonts.encodeSans(fontSize: 24, color: Colors.purple),
        ),
        centerTitle: true,
        actions: const [
          Text(
            'In-Restaurant order',
            style: TextStyle(color: Colors.black),
          )
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const SizedBox(
            height: 20,
          ),
          SizedBox(
              height: 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                    child: Text(
                      'Popular Restaurants',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    height: 120,
                    color: Colors.purple[50],
                    width: double.infinity,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        ...(_restaurantList.map(
                          (eachRes) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          RestaurantView(restaurant: eachRes)));
                            },
                            child: CachedNetworkImage(
                              imageUrl: eachRes['data']['picture'],
                              imageBuilder: (context, imageProvider) =>
                                  SizedBox(
                                width: 140,
                                height: 120,
                                child: Card(
                                  child: Stack(
                                    children: [
                                      Image(
                                        image: imageProvider,
                                        fit: BoxFit.contain,
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          padding: const EdgeInsets.all(4),
                                          width: 30,
                                          height: 30,
                                          margin:
                                              EdgeInsets.only(top: 3, right: 3),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.purple,
                                          ),
                                          child: Text(
                                            eachRes['data']['hits'].toString(),
                                            style: const TextStyle(
                                                fontSize: 17,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          color: Colors.white,
                                          width: 140,
                                          padding: const EdgeInsets.all(5),
                                          child: Text(
                                            eachRes['data']['restaurantName'],
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  elevation: 3,
                                ),
                              ),
                              placeholder: (context, url) {
                                return const SizedBox(
                                  width: 140,
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              },
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ))
                      ],
                    ),
                  )
                ],
              )),
          SizedBox(
              height: 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                    child: Text(
                      'Promos',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    height: 120,
                    color: Colors.purple[50],
                    width: double.infinity,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        ...(_foodListByPromos
                            .where((element) =>
                                double.parse(element['data']['discount']) > 0.0)
                            .map(
                              (eachRes) => GestureDetector(
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
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                        eachRes['data']['name'],
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18)),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      IconButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          icon: const Icon(
                                                            Icons
                                                                .cancel_outlined,
                                                            color:
                                                                Colors.purple,
                                                            size: 30,
                                                          ))
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Food_view(selectedFood: eachRes)
                                            ],
                                          ));
                                },
                                child: CachedNetworkImage(
                                  imageUrl: eachRes['data']['picture'],
                                  imageBuilder: (context, imageProvider) =>
                                      SizedBox(
                                    width: 120,
                                    child: Card(
                                      child: Stack(
                                        children: [
                                          Image(
                                            image: imageProvider,
                                            height: 160,
                                            width: 180,
                                            fit: BoxFit.contain,
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              color: Colors.red,
                                              child: Text(
                                                (eachRes['data']['discount'] +
                                                        '%')
                                                    .toString()
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 19,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              color: Colors.white,
                                              width: 120,
                                              padding: const EdgeInsets.all(5),
                                              child: Text(
                                                eachRes['data']['name'],
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      elevation: 3,
                                    ),
                                  ),
                                  placeholder: (context, url) {
                                    return const SizedBox(
                                      width: 140,
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    );
                                  },
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ))
                      ],
                    ),
                  )
                ],
              )),
          SizedBox(
              height: 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
                    child: Text(
                      'Popular Dishes',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    height: 120,
                    color: Colors.purple[50],
                    width: double.infinity,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        ...(_foodList.map(
                          (eachRes) => GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (BuildContext context) => Wrap(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                    eachRes['data']['name'],
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18)),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
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
                                            ],
                                          ),
                                          Food_view(selectedFood: eachRes)
                                        ],
                                      ));
                            },
                            child: CachedNetworkImage(
                              imageUrl: eachRes['data']['picture'],
                              imageBuilder: (context, imageProvider) =>
                                  SizedBox(
                                width: 140,
                                child: Card(
                                  child: Stack(
                                    children: [
                                      Image(
                                        image: imageProvider,
                                        fit: BoxFit.contain,
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          color: Colors.white,
                                          width: 180,
                                          padding: const EdgeInsets.all(5),
                                          child: Text(
                                            eachRes['data']['name'],
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  elevation: 3,
                                ),
                              ),
                              placeholder: (context, url) {
                                return const SizedBox(
                                  width: 140,
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              },
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ))
                      ],
                    ),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
