// ignore_for_file: file_names

import 'package:flutter/material.dart';

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
}
