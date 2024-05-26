import 'package:flutter/material.dart';
import 'package:photo_editing/provider/app_image_provider.dart';
import 'package:photo_editing/screens/adjust_screen.dart';
import 'package:photo_editing/screens/crop_screen.dart';
import 'package:photo_editing/screens/filter_screen.dart';
import 'package:photo_editing/screens/home_screen.dart';
import 'package:photo_editing/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppImageProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xff111111),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Colors.black,
          centerTitle: true,
        ),
        useMaterial3: true,
        sliderTheme: const SliderThemeData(
          showValueIndicator: ShowValueIndicator.always
        ),
      ),
  
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashScreen(),
        '/home': (_) => const HomeScreen(),
        '/crop': (_) => const CropScreen(),
        '/filter': (_) => const FilterScreen(),
        '/adjust': (_) => const AdjustScreen(),
      },
      initialRoute: '/',
    );
  }
}
