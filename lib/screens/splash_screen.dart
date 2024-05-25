import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_editing/helper/image_picker.dart';
import 'package:photo_editing/provider/app_image_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AppImageProvider imageProvider;

  @override
  void initState() {
    imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              "assets/images/splash.jpg",
              fit: BoxFit.fitHeight,
            ),
          ),
          Column(
            children: [
              const Expanded(
                child: Center(
                  child: Text(
                    "Photo Editor",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      wordSpacing: 10,
                      letterSpacing: 5,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(),
              ),
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          AppImagePicker(source: ImageSource.gallery).pick(
                              onPick: (File? image) {
                            imageProvider.changeImageFile(image!);
                            Navigator.of(context).pushReplacementNamed('/home');
                          });
                        },
                        child: const Text(
                          "Gallary",
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          AppImagePicker(source: ImageSource.camera).pick(
                              onPick: (File? image) {
                            imageProvider.changeImageFile(image!);
                            Navigator.of(context).pushReplacementNamed('/home');
                          });
                        },
                        child: const Text(
                          "Camera",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
