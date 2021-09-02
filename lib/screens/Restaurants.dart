// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:meraketme/screens/RestaurantView.dart';
import 'package:meraketme/services/FireStoreServices.dart';
import 'package:meraketme/widgets/drawerClass.dart';

class Restaurants extends StatefulWidget {
  const Restaurants({Key? key}) : super(key: key);

  @override
  _RestaurantsState createState() => _RestaurantsState();
}

class _RestaurantsState extends State<Restaurants> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
        drawer: const DrawerClass(),
        appBar: AppBar(),
        body: FutureBuilder(
            future: FireStoreServices().getRestaurants(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Oops...\n Something went wrong.',
                    textAlign: TextAlign.center,
                  ),
                );
              }

              if (snapshot.hasData) {
                var snapmap = snapshot.data! as List;
                if (snapmap.isEmpty || snapmap == null) {
                  return const Center(
                    child: Text(
                      'Could not load restaurants, come back later',
                    ),
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: _width * 0.1,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(25.0)),
                        child: TypeAheadField(
                          suggestionsCallback: (pattern) async {
                            if (pattern.isNotEmpty) {
                              return snapmap.where((element) => element['data']
                                      ['name']
                                  .toString()
                                  .toLowerCase()
                                  .contains(
                                      pattern.toString().trim().toLowerCase()));
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        RestaurantView(
                                            restaurant: suggestion)));
                          },
                          textFieldConfiguration: const TextFieldConfiguration(
                            autofocus: false,
                            decoration: InputDecoration(
                                icon: Icon(Icons.search),
                                // enabledBorder: UnderlineInputBorder(
                                //     borderSide:
                                //         BorderSide(color: Colors.purple)),
                                // focusedBorder: UnderlineInputBorder(
                                //     borderSide:
                                //         BorderSide(color: Colors.purple)),
                                // border: UnderlineInputBorder(
                                //     borderSide:
                                //         BorderSide(color: Colors.purple)),
                                hintText: 'Popeyes',
                                labelText:
                                    'Search for your favorite restaurant?',
                                labelStyle: TextStyle(color: Colors.black)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: _width * 0.1,
                      ),
                      SizedBox(
                        height: 210,
                        width: _width,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children: [
                            ...(snapmap
                                .map((item) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 10),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          RestaurantView(
                                                            restaurant: item,
                                                          )));
                                        },
                                        child: Card(
                                            child: Stack(
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: item['data']['picture'],
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                height: 200,
                                                width: 200,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    onError: (error, stack) {
                                                      debugPrint(
                                                          error.toString());
                                                    },
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              placeholder: (context, url) {
                                                debugPrint(url);
                                                return const CircularProgressIndicator();
                                              },
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                            Container(
                                              height: 200,
                                              width: 200,
                                              alignment: Alignment.bottomCenter,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                margin: const EdgeInsets.only(
                                                    bottom: 10,
                                                    left: 10,
                                                    right: 10),
                                                decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        item['data']['name'],
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                      ),
                                                    ]),
                                              ),
                                            )
                                          ],
                                        )),
                                      ),
                                    ))
                                .toList())
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }

              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(),
                    Text('Loading...')
                  ],
                ),
              );
            }));
  }
}
