// ignore_for_file: file_names

import 'package:flutter/material.dart';
import './globals.dart' as globals;

class OtherServices {
  Future getSearchPattern(
      String pattern, String location, String category, List items) async {
    var filteredItem = category == 'All Categories'
        ? items.where((element) {
            // debugPrint(pattern.trim());
            return element['data']['location'] == location &&
                element['data']['name']
                    .toString()
                    .toLowerCase()
                    .contains(pattern.trim().toLowerCase());
          })
        : items.where((element) =>
            element['data']['category'] == category &&
            element['data']['location'] == location &&
            element['data']['name']
                .toString()
                .toLowerCase()
                .contains(pattern.trim().toLowerCase()));
    //debugPrint('filtered items: ' + filteredItem.toString());

    return filteredItem;
  }

  Future getStatePattern(String state) async {
    var filteredItems = globals.states
        .where((e) => e.keys.first.toLowerCase().contains(state.toLowerCase()))
        .map((e) => e.keys.first);

    return filteredItems;
  }

  Future getLgaPattern(String state, String lga) async {
    var filteredItems = globals.states.firstWhere(
        (element) => (element.keys.first.toLowerCase() == state.toLowerCase()));

    var filtered = filteredItems.values.first
        .where((e) => e.toString().toLowerCase().contains(lga.toLowerCase()));
    return filtered;
  }
}
