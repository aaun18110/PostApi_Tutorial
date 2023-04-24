// ignore_for_file: avoid_print, unused_local_variable, unnecessary_new

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homescreen.dart';

class UploadImages extends StatefulWidget {
  const UploadImages({Key? key}) : super(key: key);

  @override
  State<UploadImages> createState() => _UploadImagesState();
}

class _UploadImagesState extends State<UploadImages> {
  File? image;
  final _picker = ImagePicker();
  bool spinner = false;

  void saveData(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
    setState(() {});
  }

  Future getImage() async {
    final pickImage =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    // final directoryPath = await getApplicationDocumentsDirectory();
    // final path = directoryPath.path;
    // final imageFile = File(pickImage!.path).copy('$path');

    // saveData('image', imageFile.toString());

    // setState(() {
    //   image = File(pickImage.path);
    // });

    if (pickImage != null) {
      image = File(pickImage.path);
      setState(() {});
    } else {
      print("image not found");
    }
  }

  Future<void> uploadIamge() async {
    setState(() {
      spinner = true;
    });
    var stream = new http.ByteStream(image!.openRead());
    stream.cast();
    var length = await image!.length();
    var uri = Uri.parse("https://fakestoreapi.com/products");
    var request = new http.MultipartRequest('POST', uri);
    // request.fields['title'] = "Static title";
    var multiPort = new http.MultipartFile('image', stream, length);
    request.files.add(multiPort);
    var response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        spinner = false;
      });
      print('Uploaded sucessfully');
    } else {
      print('Uploaded failed');
      setState(() {
        spinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("build image");
    return ModalProgressHUD(
      inAsyncCall: spinner,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Upload Images'),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  getImage();
                },
                child: Container(
                  width: 200,
                  height: 200,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black12)),
                  child: image == null
                      ? const Center(child: Text("Choose Your image"))
                      : Image.file(
                          File(image!.path).absolute,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                        ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              image == null
                  ? InkWell(
                      onTap: () {
                        print("pick Image");
                        getImage();
                      },
                      child: Container(
                        width: 200,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.blue[500],
                            borderRadius: BorderRadius.circular(14)),
                        child: const Center(
                            child: Text(
                          "Choose Image",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        print("upload image");
                        uploadIamge();
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const HomeScreen()));
                      },
                      child: Container(
                        width: 200,
                        height: 60,
                        decoration: BoxDecoration(
                            color: Colors.blue[500],
                            borderRadius: BorderRadius.circular(14)),
                        child: const Center(
                            child: Text(
                          "Upload",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
