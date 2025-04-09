import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'page/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(

      //ddta lihat di file google-services.json
      apiKey: 'AIzaSyDDGNnc42l8hyLCoKQQi-QESDAtSTSheK0', //current_key
      appId: '1:145103538924:android:ecea13bb3d97327fa333c9', //mobilesdk_app_id
      messagingSenderId: '145103538924', //project_number
      projectId: 'flutter-absensi-app-c2b50'), //project_id
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        cardTheme: const CardTheme(surfaceTintColor: Colors.white),
        dialogTheme: const DialogTheme(surfaceTintColor: Colors.white, backgroundColor: Colors.white),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}
