import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Backups {
  final itemsBox = Hive.box("itemsBox");
  List<Map<dynamic, dynamic>> itemlist = [];

  Future checkconnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      print("taking back up...........");
      if (itemsBox.isNotEmpty) {
        itemsBox.toMap().forEach((key, value) {
          itemlist.add({"key": key, "value": value});
        });
      }
      print(itemlist);

      DocumentReference documentReference =
          FirebaseFirestore.instance.collection("debtors").doc("682410476");

// Set the data for the document
      documentReference.set({
        'items': itemlist,
        'store name': "hirey",
      });
    } else {
      print("internmet ma heysataa");
    }
  }
}
