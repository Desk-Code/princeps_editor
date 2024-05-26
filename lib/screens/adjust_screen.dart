import 'dart:typed_data';

import 'package:colorfilter_generator/addons.dart';
import 'package:colorfilter_generator/colorfilter_generator.dart';
import 'package:flutter/material.dart';
import 'package:photo_editing/provider/app_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class AdjustScreen extends StatefulWidget {
  const AdjustScreen({super.key});

  @override
  State<AdjustScreen> createState() => _AdjustScreenState();
}

class _AdjustScreenState extends State<AdjustScreen> {
  late AppImageProvider appImageProvider;
  ScreenshotController screenshotController = ScreenshotController();

  double brightness = 0;
  double contrast = 0;
  double saturation = 0;
  double hue = 0;
  double sepia = 0;

  bool showBrightness = true;
  bool showContrast = false;
  bool showSituration = false;
  bool showHue = false;
  bool showSepia = false;

  late ColorFilterGenerator adj;

  @override
  void initState() {
    appImageProvider = Provider.of<AppImageProvider>(context, listen: false);
    adjust();
    super.initState();
  }

  void adjust({brightness, contrast, saturation, hue, sepia}) {
    adj = ColorFilterGenerator(
      name: 'Adjust',
      filters: [
        ColorFilterAddons.brightness(brightness ?? this.brightness),
        ColorFilterAddons.contrast(contrast ?? this.contrast),
        ColorFilterAddons.saturation(saturation ?? this.saturation),
        ColorFilterAddons.hue(hue ?? this.hue),
        ColorFilterAddons.sepia(sepia ?? this.sepia),
      ],
    );
  }

  void showSlider({brightness, contrast, saturation, hue, sepia}) {
    setState(() {
      showBrightness = brightness != null ? true : false;
      showContrast = contrast != null ? true : false;
      showSituration = saturation != null ? true : false;
      showHue = hue != null ? true : false;
      showSepia = sepia != null ? true : false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(
          style: ButtonStyle(iconColor: WidgetStatePropertyAll(Colors.white)),
        ),
        title: const Text(
          "Adjust",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              Uint8List? image = await screenshotController.capture();
              appImageProvider.changeImage(image!);
              if (!mounted) return;
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.done,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Consumer<AppImageProvider>(
              builder: (BuildContext context, value, Widget? child) {
                if (value.currentImage != null) {
                  return Screenshot(
                    controller: screenshotController,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.matrix(adj.matrix),
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Visibility(
                        visible: showBrightness,
                        child: slider(
                            value: brightness,
                            onChanged: (value) {
                              setState(() {
                                brightness = value;
                                adjust(
                                  brightness: brightness,
                                );
                              });
                            }),
                      ),
                      Visibility(
                        visible: showContrast,
                        child: slider(
                            value: contrast,
                            onChanged: (value) {
                              setState(() {
                                contrast = value;
                                adjust(
                                  contrast: contrast,
                                );
                              });
                            }),
                      ),
                      Visibility(
                        visible: showSituration,
                        child: slider(
                            value: saturation,
                            onChanged: (value) {
                              setState(() {
                                saturation = value;
                                adjust(
                                  saturation: saturation,
                                );
                              });
                            }),
                      ),
                      Visibility(
                        visible: showHue,
                        child: slider(
                            value: hue,
                            onChanged: (value) {
                              setState(() {
                                hue = value;
                                adjust(
                                  hue: hue,
                                );
                              });
                            }),
                      ),
                      Visibility(
                        visible: showSepia,
                        child: slider(
                            value: sepia,
                            onChanged: (value) {
                              setState(() {
                                sepia = value;
                                adjust(
                                  sepia: sepia,
                                );
                              });
                            }),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      brightness = 0;
                      contrast = 0;
                      saturation = 0;
                      hue = 0;
                      sepia = 0;
                    });
                    adjust(
                        brightness: brightness,
                        contrast: contrast,
                        saturation: saturation,
                        hue: hue,
                        sepia: sepia);
                  },
                  child: const Text(
                    'Reset',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
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
                Icons.brightness_4_rounded,
                'Brightness',
                color: showBrightness ? Colors.blue : null,
                onPress: () {
                  showSlider(brightness: true);
                },
              ),
              _bottomBarItem(
                Icons.contrast,
                'Contrast',
                color: showContrast ? Colors.blue : null,
                onPress: () {
                  showSlider(contrast: true);
                },
              ),
              _bottomBarItem(
                Icons.water_drop,
                'Situration',
                color: showSituration ? Colors.blue : null,
                onPress: () {
                  showSlider(saturation: true);
                },
              ),
              _bottomBarItem(
                Icons.filter_tilt_shift,
                'Hue',
                color: showHue ? Colors.blue : null,
                onPress: () {
                  showSlider(hue: true);
                },
              ),
              _bottomBarItem(
                Icons.motion_photos_on,
                'Sepia',
                color: showSepia ? Colors.blue : null,
                onPress: () {
                  showSlider(sepia: true);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomBarItem(IconData icon, String title,
      {Color? color, required onPress}) {
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
                color: color ?? Colors.white,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                title,
                style: TextStyle(
                  color: color ?? Colors.white70,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget slider({required value, required onChanged}) {
    return Slider(
      label: '${value.toStringAsFixed(2)}',
      min: -0.9,
      max: 1,
      value: value,
      onChanged: onChanged,
    );
  }
}
