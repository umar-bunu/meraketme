// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:meraketme/screens/RestaurantView.dart';
import 'package:meraketme/services/FireStoreServices.dart';

class Restaurants extends StatefulWidget {
  var userData;
  Restaurants({Key? key, this.userData}) : super(key: key);

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
        body: SafeArea(
      child: FutureBuilder(
          future: FireStoreServices().getRestaurants(
              widget.userData['data']['state'], widget.userData['data']['lga']),
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
                    'There is no restaurant in your current location',
                  ),
                );
              }
              return Flex(
                direction: Axis.vertical,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                        color: Colors.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(5.0)),
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
                                    RestaurantView(restaurant: suggestion)));
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
                            labelText: 'Search for your favorite restaurant?',
                            labelStyle: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Flexible(
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      children: [
                        ...(snapmap
                            .map((item) => Card(
                                  child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 10),
                                      child: ListTile(
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
                                        leading: CachedNetworkImage(
                                          imageUrl: item['data']['picture'],
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  CircleAvatar(
                                                      child: Image.network(
                                            item['data']['picture'],
                                            fit: BoxFit.contain,
                                          )),
                                          placeholder: (context, url) {
                                            debugPrint(url);
                                            return const CircularProgressIndicator();
                                          },
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                        title: Text(
                                          item['data']['restaurantName'],
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )),
                                ))
                            .toList())
                      ],
                    ),
                  )
                ],
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
          }),
    ));
  }
}
