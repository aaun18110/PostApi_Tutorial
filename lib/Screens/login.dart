// ignore_for_file: avoid_print, unused_local_variable, use_build_context_synchronously

import 'dart:convert';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:post_api/Screens/upload_images.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String emails = "eve.holt@reqres.in";
  String passwords = "pistol";

  bool isHidden = true;
  void showPassword() {
    isHidden = !isHidden;
    setState(() {});
  }

  void login(String email, String password) async {
    try {
      Response response = await post(
          Uri.parse("https://reqres.in/api/register"),
          body: {'email': email, 'password': password});
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        return print("sucessfully");
      } else {
        return print("failed");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    print("LogIn Screen");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                    hintText: "Email", prefixIcon: Icon(Icons.email_rounded)),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: isHidden,
                controller: passwordController,
                // maxLength: 8,
                decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: InkWell(
                      onTap: () {
                        showPassword();
                      },
                      child: Icon(isHidden
                          ? Icons.visibility_sharp
                          : Icons.visibility_off),
                    )),
              ),
              const SizedBox(
                height: 40,
              ),
              InkWell(
                  onTap: () async {
                    print("tap");
                    if (emailController.text.isEmpty &&
                        passwordController.text.isEmpty) {
                      AnimatedSnackBar.material(
                        'Input fields are empty',
                        type: AnimatedSnackBarType.warning,
                        duration: const Duration(milliseconds: 10),
                        desktopSnackBarPosition:
                            DesktopSnackBarPosition.topCenter,
                      ).show(context);
                    } else {
                      if (emailController.text.toString() == emails &&
                          passwordController.text.toString() == passwords) {
                        login(emailController.text.toString(),
                            passwordController.text.toString());
                        AnimatedSnackBar.material(
                          'Login Sucessfully',
                          type: AnimatedSnackBarType.info,
                          duration: const Duration(milliseconds: 10),
                          desktopSnackBarPosition:
                              DesktopSnackBarPosition.topCenter,
                        ).show(context);
                        emailController.clear();
                        passwordController.clear();
                        print("object");
                        SharedPreferences sp =
                            await SharedPreferences.getInstance();
                        sp.setBool("login", true);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UploadImages()));
                      } else {
                        return AnimatedSnackBar.material(
                          'Your email & password is invalid!',
                          type: AnimatedSnackBarType.warning,
                          duration: const Duration(milliseconds: 10),
                          desktopSnackBarPosition:
                              DesktopSnackBarPosition.topCenter,
                        ).show(context);
                      }
                    }
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.blue[800],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.blue, width: 2)),
                      child: const Center(
                          child: Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      )),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
