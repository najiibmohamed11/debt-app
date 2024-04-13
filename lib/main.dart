import 'package:debt_manager/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure initializations occur before runApp

  try {
    await Hive.initFlutter(); // Initialize Hive for the Flutter environment

    var debtorsBox = await Hive.openBox('debtorsBox'); // Open a box for debtors
    var itemsBox = await Hive.openBox('itemsBox'); // Open a box for items

    runApp(const MyApp()); // Run the app
  } catch (e) {
    print(
        'Error initializing app: $e'); // Print any errors during initialization
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Home(),
      theme: ThemeData(
        // Optional: Define a theme for the application
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false, // Disable the debug banner
    );
  }
}
