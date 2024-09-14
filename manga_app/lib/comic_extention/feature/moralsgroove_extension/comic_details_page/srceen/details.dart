import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../widget/loading.dart';
import '../../chap_detail/chapdetail.dart';
import '../../home_page/controller/comicController.dart';

class ComicMortalsDetail extends StatelessWidget {


  final ComicMotalsController controller = Get.find();

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(controller.comic.value.image),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                ),
                actions: [
                  // Obx(() {
                  //   return IconButton(
                  //     onPressed: () {
                  //       controller.changeLike(!controller.isLike);
                  //     },
                  //     icon: Icon(
                  //       controller.isLike ? Icons.star : Icons.star_border,
                  //       color: Colors.white,
                  //     ),
                  //   );
                  // }),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).padding.top,
                                left: 10,
                                right: 10
                            ),
                            width: 100.w - 100,
                            height:((100.w - 100 )*1.5 )+20,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(13),
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(controller.comic.value.image),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  width: 100.w - 100,
                                  height:((100.w - 100)*1.5),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 40,
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
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  margin: EdgeInsets.only(bottom: 20,left: 0,right: 0),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15.px,
                                      vertical: 10.px,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.white24,
                                          Colors.black26,
                                          Colors.black54,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Container(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'FIRST CHAPTER',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    //controller.fetchChapter(comic.linkDetail.split(" ")[0], int.parse(controller.chapterList[controller.chapterList.length - 1].linkDetail));
                                    final firstChapterNumber = int.parse(controller.chapterList.first.name);
                                    final lastChapterNumber = int.parse(controller.chapterList.last.name);
                                    final targetIndex = firstChapterNumber > lastChapterNumber
                                        ? controller.chapterList.length - 1
                                        : 0;
                                    print("chap: ${controller.chapterList.first.name}");
                                    controller.getChapterImg(controller.chapterList[targetIndex].linkDetail);
                                    Get.to(() => ChapDetail(
                                        index: targetIndex));
                                  },
                                ),
                                GestureDetector(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15.px,
                                      vertical: 10.px,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.white24,
                                          Colors.black26,
                                          Colors.black54,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Container(
                                      //padding: EdgeInsets.only(left: 40),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'NEW CHAPTER',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  onTap: () async {
                                    //controller.fetchChapter(comic.linkDetail.split(" ")[0], int.parse(controller.chapterList[0].linkDetail));
                                    final firstChapterNumber = int.parse(controller.chapterList.first.name);
                                    final lastChapterNumber = int.parse(controller.chapterList.last.name);
                                    final targetIndex = firstChapterNumber > lastChapterNumber
                                        ? 0
                                        : controller.chapterList.length - 1;
                                    print("chap: ${controller.chapterList.first.name}");
                                    controller.getChapterImg(controller.chapterList[targetIndex].linkDetail);
                                    Get.to(() => ChapDetail(
                                        index: targetIndex));
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),

                      /// title
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 2.h,
                        ),
                        child: Text(
                          controller.comic.value.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      /// category
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 5.0,
                          children: [
                            ...controller.comic.value.categoryComics.map((category) {
                              return GestureDetector
                                (
                                child: Chip(label: Text('${category.name}'), backgroundColor: Colors.black26,),
                                onTap: () {
                                },
                              );
                            }).toList()
                          ],
                        ),
                      ),

                      /// description
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 2.h),
                        child: Text(
                          controller.comic.value.description,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Chapter List',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  controller.sortChapters();
                                },
                                icon: Icon(Icons.sort, color: Colors.white),
                              ),
                            ],
                          ),
                          Obx(() {
                            if (controller.isDetailLoading.value) {
                              return Center(child: LoadingWidget());
                            } else if (controller.errorDetailMessage.isNotEmpty) {
                              return Center(
                                child: Text(controller.errorDetailMessage.value,
                                    style: TextStyle(color: Colors.white)),
                              );
                            } else {
                              return ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.all(8),
                                itemCount: controller.chapterList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      print(index);
                                        //controller.fetchChapter(comic.linkDetail.split(" ")[0], int.parse(controller.chapterList[index].linkDetail));
                                        controller.getChapterImg(controller.chapterList[index].linkDetail);
                                        Get.to(() => ChapDetail(
                                            index: index));
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Chapter ${controller.chapterList[index].name}',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              color: Colors.white
                                            ),
                                          ),
                                          Text(
                                            '${controller.chapterList[index].dateUpdate}',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.grey.withOpacity(0.5)
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder: (BuildContext context, int index) => const Divider(),
                              );
                            }
                          }),
                        ],
                      ),
                      SizedBox(height: 2.h,),
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
