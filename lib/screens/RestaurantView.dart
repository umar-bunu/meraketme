// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:meraketme/services/FireStoreServices.dart';
import 'package:meraketme/widgets/food_view.dart';

class RestaurantView extends StatefulWidget {
  final restaurant;
  const RestaurantView({Key? key, required this.restaurant}) : super(key: key);

  @override
  _RestaurantViewState createState() => _RestaurantViewState();
}

class _RestaurantViewState extends State<RestaurantView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.purple),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: FireStoreServices()
                .getRestaurantDetails(widget.restaurant['data']['email']),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'Oops...\n Could not load data',
                    textAlign: TextAlign.center,
                  ),
                );
              }
              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              var snapmap = snapshot.data as List;
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CachedNetworkImage(
                      imageUrl: widget.restaurant['data']['picture'],
                      imageBuilder: (context, imageProvider) => Container(
                        alignment: Alignment.center,
                        child: snapshot.hasError
                            ? const SizedBox()
                            : Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(10)),
                                child: TypeAheadField(
                                  suggestionsCallback: (pattern) async {
                                    if (pattern.isNotEmpty) {
                                      List _snapmap = snapshot.data as List;
                                      return _snapmap
                                          .where((element) => element['data']
                                                  ['name']
                                              .toString()
                                              .toLowerCase()
                                              .contains(pattern.toLowerCase()))
                                          .toList();
                                    } else {
                                      return [];
                                    }
                                  },
                                  itemBuilder: (_, item) {
                                    var itemName = item as Map;
                                    return ListTile(
                                      leading: CachedNetworkImage(
                                        imageUrl: itemName['data']['picture'],
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                CircleAvatar(
                                          radius: 15,
                                          backgroundImage: imageProvider,
                                        ),
                                        placeholder: (context, url) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                      title:
                                          Text(item['data']['name'].toString()),
                                    );
                                  },
                                  onSuggestionSelected: (suggestion) {
                                    Map suggestionMap = suggestion as Map;
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
                                                          suggestionMap['data']
                                                              ['name'],
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      18)),
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
                                                Food_view(
                                                    selectedFood: suggestion)
                                              ],
                                            ));
                                  },
                                  textFieldConfiguration:
                                      const TextFieldConfiguration(
                                    autofocus: false,
                                    decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        icon: Icon(Icons.search),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.purple)),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.purple)),
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.purple)),
                                        hintText: 'Cheese burger',
                                        labelText:
                                            'Search for your favorite food?',
                                        labelStyle:
                                            TextStyle(color: Colors.black)),
                                  ),
                                ),
                              ),
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            onError: (error, stack) {
                              debugPrint(error.toString());
                            },
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) {
                        return const CircularProgressIndicator();
                      },
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Flexible(
                      child: Scrollbar(
                        isAlwaysShown: true,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            ...(snapmap.map(
                              (e) => Card(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: ListTile(
                                    onTap: () {
                                      showModalBottomSheet(
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (BuildContext context) =>
                                              Wrap(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            e['data']['name'],
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        18)),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          IconButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              icon: const Icon(
                                                                Icons
                                                                    .cancel_outlined,
                                                                color: Colors
                                                                    .purple,
                                                                size: 30,
                                                              ))
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Food_view(selectedFood: e)
                                                ],
                                              ));
                                    },
                                    leading: CachedNetworkImage(
                                      imageUrl: e['data']['picture'],
                                      imageBuilder: (context, imageProvider) =>
                                          GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          child: snapshot.hasError
                                              ? const SizedBox()
                                              : Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                ),
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              onError: (error, stack) {
                                                debugPrint(error.toString());
                                              },
                                              image: imageProvider,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) {
                                        return const CircularProgressIndicator();
                                      },
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                    title: Text(e['data']['name']),
                                    trailing: Text(
                                      'N' + e['data']['price'],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
