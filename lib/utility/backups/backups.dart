import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Backups {
  final itemsBox = Hive.box("itemsBox");
  final debtorsBox = Hive.box("debtorsBox");

  var currentuser = FirebaseAuth.instance.currentUser;
  List<Map<dynamic, dynamic>> itemslist = [];
  List<Map<dynamic, dynamic>> debtorslist = [];

  Future takebackup() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      print("Connected. Preparing to backup...");

      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("debtors")
          .doc("${currentuser!.phoneNumber}");

      // First, delete the existing document
      await documentReference.delete();

      // Check if local data is available to backup
      itemslist.clear();
      debtorslist.clear();
      if (debtorsBox.isNotEmpty) {
        itemsBox.toMap().forEach((key, value) {
          itemslist.add({"key": key, "value": value});
        });
        debtorsBox.toMap().forEach((key, value) {
          debtorslist.add({"key": key, "value": value});
        });
      }

      // Create a new document with the backup data
      await documentReference.set({
        'items': itemslist,
        "debtors":debtorslist,
        'store name': "${currentuser!.displayName}",
      });
      print("Backup taken successfully.");
    } else {
      print("No internet connection.");
    }
  }
}
