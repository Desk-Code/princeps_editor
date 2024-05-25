import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_editing/helper/filters.dart';
import 'package:photo_editing/model/filter_model.dart';
import 'package:photo_editing/provider/app_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late Filter currentFilter;
  late List<Filter> filters;
  late AppImageProvider appImageProvider;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    appImageProvider = Provider.of<AppImageProvider>(context, listen: false);
    filters = Filters().list();
    currentFilter = filters[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(
          style: ButtonStyle(iconColor: WidgetStatePropertyAll(Colors.white)),
        ),
        title: const Text(
          "Filters",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              Uint8List? bytes = await screenshotController.capture();
              appImageProvider.changeImage(bytes!);
              if (!mounted) return;
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.done,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Center(
        child: Consumer<AppImageProvider>(
          builder: (BuildContext context, value, Widget? child) {
            if (value.currentImage != null) {
              return Screenshot(
                controller: screenshotController,
                child: ColorFiltered(
                  colorFilter: ColorFilter.matrix(currentFilter.matrix),
                  child: Image.memory(
                    value.currentImage!,
                  ),
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        height: 100,
        width: double.infinity,
        color: Colors.black,
        child: SafeArea(
          child: Consumer<AppImageProvider>(
            builder: (BuildContext context, value, Widget? child) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                itemBuilder: (context, index) {
                  Filter filter = filters[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  currentFilter = filter;
                                });
                              },
                              child: ColorFiltered(
                                colorFilter: ColorFilter.matrix(filter.matrix),
                                child: Image.memory(value.currentImage!),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          filter.filterName,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
