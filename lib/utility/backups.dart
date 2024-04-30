import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Backups {
  final itemsBox = Hive.box("itemsBox");
  List<Map<dynamic, dynamic>> itemlist = [];

  Future checkconnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      print("Connected. Preparing to backup...");

      DocumentReference documentReference =
          FirebaseFirestore.instance.collection("debtors").doc("682410476");

      // First, delete the existing document
      await documentReference.delete();
      print("Existing data deleted.");

      // Check if local data is available to backup
      if (itemsBox.isNotEmpty) {
        itemsBox.toMap().forEach((key, value) {
          itemlist.add({"key": key, "value": value});
        });
      }
      print(itemlist);

      // Create a new document with the backup data
      await documentReference.set({
        'items': itemlist,
        'store name': "hirey",
      });
      print("Backup taken successfully.");
    } else {
      print("No internet connection.");
    }
  }
}
