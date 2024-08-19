import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manga_app/comic_extention/feature/home_page/screen/home/widget/comic_widget.dart';import 'package:sizer/sizer.dart';
import '../../../../model/comic.dart';
import '../../../comic_details_page/srceen/comicDetails/details.dart';
import '../../controller/comicController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';


class HomePageAsura extends StatelessWidget {
  final ComicController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background with blur effect
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background2.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
            // Main content
            Column(
              children: [
                // Transparent AppBar
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Container(
                    margin: EdgeInsets.symmetric(horizontal: 25.w),
                    padding: EdgeInsets.only(right: 10.w),
                    child: Text(
                      "Zscan",
                      style: TextStyle(fontSize: 15.sp, color: Colors.white),
                    ),
                  ),
                  leading: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
                // Content
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return Center(child: CircularProgressIndicator());
                    } else if (controller.errorMessage.isNotEmpty) {
                      return Center(child: Text(controller.errorMessage.value));
                    } else {
                      return Scrollbar(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildCarouselSlider(controller),
                              _buildSectionTitle("Last Update"),

                              controller.newComics.isNotEmpty
                                  ? ComicWidget() // Use the ComicWidget here
                                  : Text("Nothing New", style: TextStyle(color: Colors.white)),

                              _buildTabBar(controller),
                            _buildPopularAll(controller.comics), // Use the ComicWidget again if needed
                            ],
                          ),
                        ),
                      );
                    }
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularAll(List<ComicsModel> comics) {
    if(comics.isEmpty) {
      return const SizedBox();
    }
    return  Container(
      margin: EdgeInsets.only(top: 10,bottom: 30),
      child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          primary: false,
          itemCount:comics.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 180.0,
              childAspectRatio: 0.6
          ),
          itemBuilder: (context, i) => LayoutBuilder(
            builder: (context, constraints) {
              var data = comics[i];
              return GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(left: 5,right: 5,bottom: 10),
                    color: Colors.transparent,
                    child: Stack(
                      children: [
                        Container(
                          child: CachedNetworkImage(
                            imageUrl: data.image,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ) ,
                            placeholder: (context, url) => Container(
                              child: Stack(
                                children: [
                                  Image.asset('assets/images/comicbook2.png',fit: BoxFit.fitHeight,),
                                  Positioned.fill(child: Align(alignment: Alignment.center,child: CircularProgressIndicator(strokeWidth: 1,),))
                                ],
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              child: Stack(
                                children: [
                                  Image.asset('assets/images/comicbook2.png',fit: BoxFit.fitHeight,),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black54,
                                    Colors.black87,
                                  ],
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 5, right: 5),
                                child: Center(
                                  child: Text(
                                    data.title,
                                    maxLines: 3,
                                    overflow:
                                    TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  onTap:(){
                    onTap: () {
                      Get.to(() => ComicDetail(comic: data));
                    };
                  });
            },
          )
      ),
    );
  }
  Widget _buildTabBar(ComicController controller) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton(
            child: Text(
              "All",
              style: controller.tabChange == 1
                  ? TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp, color: Colors.white)
                  : TextStyle(color: Colors.white),
            ),
            onPressed: () {
              controller.changeTab(1);
            },
          ),
          TextButton(
            child: Text(
              "Month",
              style: controller.tabChange == 2
                  ? TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp, color: Colors.white)
                  : TextStyle(color: Colors.white),
            ),
            onPressed: () {
              controller.changeTab(2);
            },
          ),
          TextButton(
            child: Text(
              "Week",
              style: controller.tabChange == 3
                  ? TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp, color: Colors.white)
                  : TextStyle(color: Colors.white),
            ),
            onPressed: () {
              controller.changeTab(3);
            },
          ),
          TextButton(
            child: Text(
              "Today",
              style: controller.tabChange == 4
                  ? TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp, color: Colors.white)
                  : TextStyle(color: Colors.white),
            ),
            onPressed: () {
              controller.changeTab(4);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselSlider(ComicController controller) {
    return CarouselSlider(
      options: CarouselOptions(
        viewportFraction: 0.8,
        aspectRatio: 16 / 8,
        initialPage: 0,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
        autoPlay: true,
      ),
      items: controller.comics.map((comic) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: GestureDetector(
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: comic.image,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          image: DecorationImage(
                              alignment: Alignment.topCenter,
                              image: imageProvider,
                              fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        child: Image.asset(
                          'assets/images/comicbook.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/images/comicbook.png',
                              fit: BoxFit.fill),
                    ),
                    Container(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black12,
                                  Colors.black26,
                                  Colors.black54,
                                  Colors.black87,
                                  Colors.black,
                                ],
                              ),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: Radius.circular(10.0))),
                          child: Center(
                            child: Text(
                              comic.title,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                onTap: () {
                  Get.to(() => ComicDetail(comic: comic));
                },
              ),
            );
          },
        );
      }).toList(),
    );
  }

  // Builds the title for sections
  Widget _buildSectionTitle(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      margin: EdgeInsets.only(top: 4.h),
      child: Text(
        title,
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w300, color: Colors.white),
      ),
    );
  }
}
