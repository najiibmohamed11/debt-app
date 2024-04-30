import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RestoringBackups {
  final itemsBox = Hive.box("itemsBox");
  final debtorsBox = Hive.box("debtorsBox");
  var currentUser = FirebaseAuth.instance.currentUser;

  Future restoreData() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      print("Connected. Preparing to restore data...");

      // Fetch data from Firestore
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("debtors")
          .doc("${currentUser!.phoneNumber}");

      try {
        DocumentSnapshot snapshot = await documentReference.get();
        if (snapshot.exists) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          List<dynamic> items = data['items'];
          List<dynamic> dbtors = data['debtors'];

          // Clear the Hive box before restoring
       

          // Restore data to Hive box
          for (var item in items) {
            await itemsBox.put(item['key'], item['value']);
          }
          for (var debtor in dbtors) {
            await debtorsBox.put(debtor['key'],debtor['value']);
          }

          print("Data restored successfully.");
        } else {
          print("No backup data found.");
        }
      } catch (e) {
        print("Error retrieving data: $e");
      }
    } else {
      print("No internet connection.");
    }
  }
}
