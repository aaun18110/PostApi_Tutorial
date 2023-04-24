import 'package:flutter/material.dart';
import 'package:post_api/Screens/upload_images.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/login.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sp = await SharedPreferences.getInstance();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.blue),
    home:
        sp.getBool("login") == true ? const UploadImages() : const LoginScreen(),
  ));
}
