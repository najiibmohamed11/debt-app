import 'dart:io';
import 'dart:typed_data';
import 'package:debt_manager/pages/home.dart';
import 'package:debt_manager/pages/phonauth.dart';
import 'package:debt_manager/profider/profider.dart';
import 'package:debt_manager/utility/backups/restoringbackup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart'; // Required for file operations

class EditProfileFirst extends StatefulWidget {
  const EditProfileFirst({Key? key}) : super(key: key);
  static String id = "EditProfileFirst";

  @override
  State<EditProfileFirst> createState() => _EditProfileFirstState();
}

class _EditProfileFirstState extends State<EditProfileFirst> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  late TextEditingController _controller;
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  File? imageFile;
  final userbox = Hive.box('usercridatial');

  Future<void> imagepicker(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageBytes =
          await image.readAsBytes(); // Convert image to byte array
      final tempImage = File(image.path); // Temporary file to show in UI
      setState(() {
        imageFile = tempImage;
      });

      // Save the byte array to Hive
      userbox.put('image', imageBytes);
    } catch (e) {
      print("Failed to pick an image: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: currentUser?.displayName ?? "");

    // Retrieve image bytes from Hive and convert to File if not null
    _loadImageFromHive();
  }

  Future<void> _loadImageFromHive() async {
    final imageBytes = userbox.get('image') as Uint8List?;
    if (imageBytes != null) {
      // Create a temporary file to display the image
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/temp_image');
      await tempFile.writeAsBytes(imageBytes);
      setState(() {
        imageFile = tempFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UseridGenerator>(builder: (context, value, child) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Edit profile", style: TextStyle(color: Colors.green)),
          backgroundColor: Colors.white10,
        ),
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                    "Please enter your store name and the image is optional"),
              ),
              SizedBox(height: 30.0),
              GestureDetector(
                onTap: () async {
                  await imagepicker(ImageSource.gallery);
                },
                child: Container(
                  width: 180,
                  height: 180,
                  child: imageFile != null
                      ? ClipOval(child: Image.file(imageFile!))
                      : Icon(Icons.add_a_photo, size: 90),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(100)),
                ),
              ),
              SizedBox(height: 40.0),
              Container(
                width: 340,
                child: TextFormField(
                  controller: _controller,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    hintStyle: TextStyle(color: Colors.green),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Colors.green),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Colors.green),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    textStyle:
                        MaterialStateProperty.all(TextStyle(fontSize: 16)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      currentUser
                          ?.updateDisplayName(_controller.text)
                          .then((_) {
                        print(
                            currentUser?.displayName); // Print new display name
                      }).catchError((e) {
                        print('Error updating display name: $e');
                      });

                      if (value.getSession() != null) {
                        userbox.put("sessionId", value.getSession());
                      } else {
                        // Handle case where session is not set
                        print("Session ID is null");
                        Navigator.pushReplacementNamed(context, PhoneAuth.id);
                        return; // Exit the function to avoid further processing
                      }

                      if (imageFile != null) {
                        userbox.put("image",
                            imageFile!.path); // Ensure imageFile is not null
                      }

                      userbox.put("store name", _controller.text);
                      Navigator.pushReplacementNamed(context, Home.id);
                    }
                  },
                  child: Text("NEXT"),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
