import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sizer/sizer.dart';
import '../../../data/model/model.dart';
import '../../../widget/loading.dart';
import '../comic_details_page/srceen/details.dart';
import '../home_page/controller/comicController.dart';

class CategoryDetail extends StatelessWidget {
  final ComicMotalsController controller = Get.find();
  final String title;

  CategoryDetail({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
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
                      title,
                      style: TextStyle(fontSize: 15.sp, color: Colors.white),
                    ),
                  ),
                  leading: IconButton(
                    onPressed: () {
                      controller.genComics.value.clear();
                      Get.back();

                    },
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
                // Content
                Expanded(
                  child: Obx(() {
                    if (controller.isCategoryComicsLoading.value) {
                      return Center(child: LoadingWidget());
                    } else if (controller.errorCategoryComicsMessage.isNotEmpty) {
                      return Center(child: Text(controller.errorCategoryComicsMessage.value));
                    } else {
                      return Scrollbar(
                        child: SingleChildScrollView(
                          child: Obx(() {
                            final comics = controller.genComics;
                            return _buildPopularAll(comics);
                          }),
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
    if (comics.isEmpty) {
      return const SizedBox();
    }
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 30),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        primary: false,
        itemCount: comics.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 180.0,
          childAspectRatio: 0.6,
        ),
        itemBuilder: (context, i) => LayoutBuilder(
          builder: (context, constraints) {
            var data = comics[i];
            return GestureDetector(
              child: Container(
                margin: EdgeInsets.only(left: 5, right: 5, bottom: 10),
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
                        ),
                        placeholder: (context, url) => Container(
                          child: Stack(
                            children: [
                              Image.asset('assets/images/comicbook2.png', fit: BoxFit.fitHeight,),
                              Positioned.fill(child: Align(alignment: Alignment.center, child: CircularProgressIndicator(strokeWidth: 1,),))
                            ],
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          child: Stack(
                            children: [
                              Image.asset('assets/images/comicbook2.png', fit: BoxFit.fitHeight,),
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
                            borderRadius: BorderRadius.circular(10),
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
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: Center(
                              child: Text(
                                data.title,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              onTap: () {
                Get.to(() => ComicMortalsDetail ());
              },
            );
          },
        ),
      ),
    );
  }
}
