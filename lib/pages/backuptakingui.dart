import 'package:debt_manager/pages/editprofilefirst.dart';
import 'package:debt_manager/utility/backups/restoringbackup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class BackupUi extends StatefulWidget {
  const BackupUi({super.key});

  @override
  State<BackupUi> createState() => _BackupUiState();
}

class _BackupUiState extends State<BackupUi> {
  bool isloading = false;
  RestoringBackups restoreyoudata = RestoringBackups();

  void handleRestore() async {
    setState(() {
      isloading = true; // Start loading before the restoration begins
    });

    try {
      await restoreyoudata.restoreData(); // Wait for restoration to complete
      print("Restoration complete.");
      // After restoration is complete, navigate away or update the UI as necessary
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => EditProfileFirst()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      // Handle errors if restoration fails
      print("Error during restoration: $e");
      setState(() {
        isloading = false; // Stop loading on failure
      });
      // Optionally show a dialog or snackbar to notify the user
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Failed to restore data. Please try again."),
            actions: <Widget>[
              MaterialButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Restoring Data", style: TextStyle(color: Colors.green)),
        backgroundColor: Colors.white10,
      ),
      body: Column(
        children: [
          SizedBox(height: 70.0),
          Icon(Icons.cloud_download, size: 100.0, color: Colors.green),
          SizedBox(height: 70.0),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "Restore your data now into the local storage of your phone. If you don't restore your data now, you will not be able to restore it later.",
                style: TextStyle(fontSize: 15.0),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Spacer(),
          isloading
              ? LinearPercentIndicator(
                  animation: true,
                  animationDuration: 2000,
                  lineHeight: 40,
                  percent: 1,
                  progressColor: Colors.green,
                  backgroundColor: Colors.grey,
                  onAnimationEnd: () {
                    // Navigate after the animation ends
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfileFirst()),
                      (Route<dynamic> route) => false,
                    );
                  },
                )
              : Column(
                  children: [
                    MaterialButton(
                      minWidth: 150,
                      onPressed: handleRestore,
                      color: Colors.green,
                      child: Text("Restore",
                          style: TextStyle(color: Colors.white, fontSize: 17)),
                    ),
                    SizedBox(height: 10.0),
                    MaterialButton(
                      minWidth: 150,
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfileFirst()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      color: Colors.grey,
                      child: Text("Skip",
                          style:
                              TextStyle(color: Colors.black38, fontSize: 17)),
                    ),
                  ],
                ),
          SizedBox(height: 50.0),
        ],
      ),
    );
  }
}
