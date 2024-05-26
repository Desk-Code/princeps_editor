import 'package:flutter/material.dart';
import 'package:photo_editing/provider/app_image_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        title: const Text(
          "Photo Editor",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: CloseButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
          style: const ButtonStyle(
              iconColor: WidgetStatePropertyAll(Colors.white)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              //
            },
            child: const Text(
              'Save',
            ),
          ),
        ],
      ),
      body: Center(
        child: Consumer<AppImageProvider>(
            builder: (BuildContext context, value, Widget? child) {
          if (value.currentImage != null) {
            return Image.memory(value.currentImage!);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 60,
        color: Colors.black,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _bottomBarItem(
                Icons.crop_rotate,
                'Crop',
                onPress: () {
                  Navigator.of(context).pushNamed('/crop');
                },
              ),
              _bottomBarItem(
                Icons.filter_vintage_outlined,
                'Filters',
                onPress: () {
                  Navigator.of(context).pushNamed('/filter');
                },
              ),
              _bottomBarItem(
                Icons.tune,
                'Adjust',
                onPress: () {
                  Navigator.of(context).pushNamed('/adjust');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomBarItem(IconData icon, String title, {required onPress}) {
    return SafeArea(
      child: InkWell(
        onTap: onPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
