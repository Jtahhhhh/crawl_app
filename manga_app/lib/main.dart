

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'comic_extention/data/model/model.dart';
import 'comic_extention/data/provider/comicprovider.dart';
import 'comic_extention/feature/home/comic_extension_homepage.dart';
import 'comic_extention/feature/moralsgroove_extension/home_page/controller/comicController.dart';
import 'comic_extention/feature/moralsgroove_extension/home_page/screen/home.dart';
import 'comic_extention/feature/reaper_extension/home_page/controller/controller.dart';
import 'comic_extention/feature/reaper_extension/home_page/srceen/home.dart';
import 'comic_extention/feature/zscan_extension/home_page/controller/comicController.dart';
import 'comic_extention/feature/zscan_extension/home_page/screen/home.dart';
import 'comic_extention/widget/customicon.dart';
import 'comic_extention/widget/backgroundwidget.dart';



void initGetxProvider() {
  Get.lazyPut(() => ComicController());
  Get.lazyPut(() => ComicMotalsController());
  Get.lazyPut(() => ComicReaperController());
}

void main() {
  initGetxProvider();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ComicsExtensionProvider()..initData()),
      ],
      child: ResponsiveSizer(
        builder: (context, orientation, deviceType) {
          return GetMaterialApp(
            title: 'Comic Extension App',
            debugShowCheckedModeBanner: false,
            home: Homepage(),
          );
        },
      ),
    );
  }
}

class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ComicsExtensionPage(),
      ),
    );
  }
}


