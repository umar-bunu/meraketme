import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meraketme/screens/Profile.dart';
import 'package:meraketme/services/FireStoreServices.dart';
import 'package:meraketme/widgets/drawerClass.dart';

class Home extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final payload;
  const Home({Key? key, this.payload}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _userData;
  List _restaurantList = [];
  List _foodList = [];
  Future _getUserData() async {
    _userData = await FireStoreServices()
        .getUserData(FirebaseAuth.instance.currentUser!.email);

    if (!_userData.exists) {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                content: const Text(
                    'You have not set up your profile yet.\nWould you like to'
                    ' set it up now?'),
                actions: [
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.red)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel')),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Colors.red)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Profile()));
                      },
                      child: const Text('Cancel')),
                ],
              ));
    } else {
      var docs = await FireStoreServices().getRestaurantsByPopular(
          _userData.data()['state'], _userData.data()['lga']);
      _restaurantList = docs['restaurants'];
      _foodList = docs['foods'];
      debugPrint('docs: ' + _restaurantList.toString());
    }
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
      appBar: AppBar(
        actions: const [Text('In-Restaurant order')],
      ),
      body: Scrollbar(
        isAlwaysShown: true,
        child: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Popular Restaurants',
                      style: TextStyle(fontSize: 22),
                    ),
                    Container(
                      height: 140,
                      color: Colors.grey[300],
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
                              child: CachedNetworkImage(
                                imageUrl: eachRes['data']['picture'],
                                imageBuilder: (context, imageProvider) =>
                                    SizedBox(
                                  width: 180,
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
                                            color: Colors.white,
                                            child: Text(
                                              eachRes['data']['hits']
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 17),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            color: Colors.white,
                                            width: 180,
                                            padding: const EdgeInsets.all(5),
                                            child: Text(
                                              eachRes['data']['restaurantName'],
                                              style: const TextStyle(
                                                  fontSize: 22,
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
                                  debugPrint(url);
                                  return const CircularProgressIndicator();
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
              height: _height * 0.3,
              child: const Text(
                'Promos',
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(
              height: _height * 0.3,
              child: const Text(
                'Popular foods',
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      drawer: const DrawerClass(),
    );
  }
}
