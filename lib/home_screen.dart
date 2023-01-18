import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:get/get.dart';
import 'package:image_slider/carousel_slider.dart';

List<Widget> carouselItems = images
    .map((cimages) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                cimages,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ))
    .toList();

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  final PageController _pageController = PageController(initialPage: 0);
  int currentPage = 0;
  late Timer timer;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    //slider time
    timer = Timer.periodic(Duration(minutes: 2), (timer) {
      if (currentPage < images.length) {
        currentPage++;
        // images[currentPage]; //think 
      } else {
        currentPage = 0;
      }
      _pageController.animateToPage(currentPage,
          duration: Duration(milliseconds: 250), curve: Curves.easeIn);
    });
  }

  Future<void> setwallpaper() async {
    int location = WallpaperManager.HOME_SCREEN;
    for (int i = 0; i < images.length; i++) {}
    var file = await DefaultCacheManager().getSingleFile(images[currentPage]);
    final bool result =
        await WallpaperManager.setWallpaperFromFile(file.path, location);
  }

  @override
  Widget build(BuildContext context) {
    // List<Widget> dotList() {
    //   List<Widget> list = [];
    //   for (int i = 0; i < images.length; i++) {
    //     list.add(i == selectedIndex ? dot(true) : dot(false));
    //   }
    //   return list;
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text("Slider"),
        centerTitle: true,
        actions: [
          GestureDetector(
              onTap: () {
                try{
                setwallpaper();
                }catch (e){
                Get.snackbar("$e", "");
                }
              },
              child: Icon(Icons.menu))
        ],
      ),
      drawer: Drawer(
        width: Get.width / 1.4,
        backgroundColor: Colors.blue,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            GestureDetector(
                onTap: () {}, child: DrawerText("Info about the image")),
            GestureDetector(
                onTap: () {}, child: DrawerText("EN: Change Langauge")),
            GestureDetector(onTap: () {}, child: DrawerText("What is OTTIO")),
            GestureDetector(
                onTap: () async {
                  try {
                    print("Its working");
                    // int location = WallpaperManager.BOTH_SCREEN;
                    // var file =
                    //     await DefaultCacheManager().getSingleFile(images[0]);
                    // bool result = await WallpaperManager.setWallpaperFromFile(
                    //     file.path, location);
                    // Get.snackbar("Image has been set", "");
                  } catch (e) {
                    Get.snackbar("$e", "");
                  }
                },
                child: DrawerText("Use as wallpaper")),
            GestureDetector(onTap: () {}, child: DrawerText("Contact Us")),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: Get.height * 0.85,
              width: Get.width,
              child: PageView(
                controller: _pageController,
                children: carouselItems,
                onPageChanged: (int page) {
                  setState(() {
                    selectedIndex = page;
                    currentPage = selectedIndex;
                    images[currentPage];
                  });
                },
              ),
            ),
          )
        ]),
      ),
    );
  }

  Padding DrawerText(var txt) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: Text(
        txt,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w400, fontSize: 18),
      ),
    );
  }
}
