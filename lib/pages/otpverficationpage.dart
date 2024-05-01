import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debt_manager/components/customdialog%20.dart';
import 'package:debt_manager/pages/backuptakingui.dart';
import 'package:debt_manager/pages/editprofilefirst.dart';
import 'package:debt_manager/profider/profider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Otpverficationpage extends StatelessWidget {
  final String number;
  final String verificationId;
  final String sessionId =
      Uuid().v4(); // Generate a new session ID for each login attempt

  Otpverficationpage(
      {Key? key, required this.number, required this.verificationId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.white,
      ),
      decoration: BoxDecoration(
        color: Colors.lightBlue,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('OTP TextField'),
        centerTitle: true,
      ),
      body: Consumer<UseridGenerator>(builder: (context, value, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            margin: const EdgeInsets.only(top: 40),
            width: double.infinity,
            child: Column(
              children: [
                const Text(
                  "Verification",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 40),
                  child: const Text(
                    "Enter the code sent to your number",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 40),
                  child: Text(
                    "+252 $number",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
                Pinput(
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: defaultPinTheme.copyWith(
                    decoration: defaultPinTheme.decoration!.copyWith(
                      border: Border.all(color: Colors.green),
                    ),
                  ),
                  onCompleted: (pin) async {
                    FirebaseAuth auth = FirebaseAuth.instance;
                    PhoneAuthCredential _credential =
                        PhoneAuthProvider.credential(
                            verificationId: verificationId, smsCode: pin);
                    auth.signInWithCredential(_credential).then((result) {
                      if (result.user != null) {
                        // Ensuring the user is not null before proceeding
                        User user = result.user!;

                        // Safely checking if this is the first login
                        DateTime? creationTime = user.metadata.creationTime;
                        DateTime lastSignInTime =
                            user.metadata.lastSignInTime ?? DateTime.now();

                        FirebaseFirestore.instance
                            .collection('user_sessions')
                            .doc(user.uid)
                            .set({
                          'sessionId': sessionId,
                        });
        Provider.of<UseridGenerator>(context, listen: false).setSession(sessionId);

                        if (creationTime != null) {
                          bool isFirstLogin = creationTime
                                  .difference(lastSignInTime)
                                  .inSeconds
                                  .abs() <
                              2;
                          if (isFirstLogin) {
                            // First login logic
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfileFirst()),
                              (Route<dynamic> route) => false,
                            );
                          } else {
                            // Logic for users who have logged in before
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BackupUi()),
                              (Route<dynamic> route) => false,
                            );
                          }
                        } else {
                          // Handle case where creationTime is null, if necessary
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfileFirst()),
                            (Route<dynamic> route) => false,
                          );
                        }
                      }
                    }).catchError((e) {
                      showDialog(
                        context: context,
                        builder: (context) => CustomDialog(
                          title: "Verification failed",
                          content:
                              "The verification code from SMS/TOTP is invalid. Please check and enter the correct verification code again.",
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      );
                    });
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
