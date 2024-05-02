import 'package:debt_manager/components/customdialog%20.dart';
import 'package:debt_manager/pages/editprofilefirst.dart';
import 'package:debt_manager/pages/home.dart';
import 'package:debt_manager/pages/otpverficationpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});
  static String id = "PhoneAuth";

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  final TextEditingController controller = TextEditingController();
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  _signInWithMobileNumber() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+252' + controller.text.trim(),
        verificationCompleted: (PhoneAuthCredential authCredential) async {
          await _auth.signInWithCredential(authCredential).then((value) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EditProfileFirst()));
          });
        },
        verificationFailed: ((error) async {
          setState(() {
            _isLoading = false;
          });
          print("errrrrrrrrrrrrrrrrrrrrrrrrrrr$error");
          showDialog(
            context: context,
            builder: (context) => CustomDialog(
              title: "Verification failed",
              
              content: error.toString(),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          );
        }),
        codeSent: (String verificationId, [int? forceResendingToken]) {
          setState(() {
            _isLoading = false;
          });
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => Otpverficationpage(
                verificationId: verificationId,
                number: controller.text,
              ),
            ),
            (Route<dynamic> route) => false,
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
        },
        timeout: Duration(seconds: 45),
      );
    } catch (e) {
      print('Error during verification: $e');
      setState(() {
        _isLoading = false;
      });
    }
   
  }

  //pop up

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: Colors.black.withOpacity(0.13)),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xffeeeeee),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          InternationalPhoneNumberInput(
                            onInputChanged: (PhoneNumber number) {},
                            onInputValidated: (bool value) {
                              print(value);
                            },
                            selectorConfig: SelectorConfig(
                              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                              showFlags: true,
                              useEmoji: true,
                            ),
                            countries: ['SO'],
                            ignoreBlank: false,
                            autoValidateMode: AutovalidateMode.disabled,
                            selectorTextStyle: TextStyle(color: Colors.black),
                            textFieldController: controller,
                            formatInput: false,
                            maxLength: 9,
                            keyboardType: TextInputType.numberWithOptions(
                                signed: true, decimal: true),
                            cursorColor: Colors.black,
                            inputDecoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(bottom: 15, left: 0),
                              border: InputBorder.none,
                              hintText: 'Phone Number',
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 16),
                            ),
                            onSaved: (PhoneNumber number) {
                              print('On Saved: $number');
                            },
                          ),
                          Positioned(
                            left: 90,
                            top: 8,
                            bottom: 8,
                            child: Container(
                              height: 40,
                              width: 1,
                              color: Colors.black.withOpacity(0.13),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 100),
                    MaterialButton(
                      minWidth: double.infinity,
                      onPressed: () async {
                        setState(() {});

                        try {
                          await _signInWithMobileNumber();
                        } catch (e) {
                          print('Error during sign in: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'An error occurred during sign-in. Please try again.'),
                            ),
                          );
                        }
                      },
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      child: Text("Request OTP",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
