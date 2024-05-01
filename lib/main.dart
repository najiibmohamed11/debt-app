import 'dart:async';

import 'package:debt_manager/pages/editprofilefirst.dart';
import 'package:debt_manager/pages/home.dart';
import 'package:debt_manager/pages/items.dart';
import 'package:debt_manager/pages/phonauth.dart';
import 'package:debt_manager/profider/profider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:debt_manager/utility/backups/backups.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  try {
    await Hive.initFlutter(); // Initialize Hive for the Flutter environment

    var debtorsBox = await Hive.openBox('debtorsBox'); // Open a box for debtors
    var itemsBox = await Hive.openBox('itemsBox'); // Open a box for items
    var userbox = await Hive.openBox('usercridatial'); // Open a box for items

    runApp(MyApp()); // Run the app
  } catch (e) {
    print(
        'Error initializing app: $e'); // Print any errors during initialization
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    backup.takebackup();
    final String initialrot = currentUser != null ? Home.id : PhoneAuth.id;

    return MultiProvider(
         providers: [ChangeNotifierProvider(create: (context) => UseridGenerator())],
      child: MaterialApp(
        initialRoute: initialrot,
      
        debugShowCheckedModeBanner: false, // Disable the debug banner
        routes: {
          Home.id: (context) => Home(key: homeStateKey),
          PhoneAuth.id: (context) => PhoneAuth(),
          EditProfileFirst.id: (context) => EditProfileFirst(),
        },
      ),
    );
  }
}
