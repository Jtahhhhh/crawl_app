import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../../../widget/loading.dart';
import '../../chap_detail/srceens/chapDetail.dart';
import '../../home_page/controller/comicController.dart';

class ComicDetail extends StatelessWidget {

  final ComicController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage( controller.comic.value.image),
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
                  icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
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
                              right: 10,
                            ),
                            width: 100.w - 100,
                            height: ((100.w - 100) * 1.5) + 20,
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
                                  height: ((100.w - 100) * 1.5),
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
                                  margin: EdgeInsets.only(bottom: 20, left: 0, right: 0),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                child: Container(
                                  height: ((100.w - 100) * 1.5) + 20,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 40,
                                      width: 150,
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
                                      child: Stack(
                                        children: [
                                          Container(
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                'FIRST CHAPTER',
                                                style: TextStyle(color: Colors.white, fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  if (controller.chapterList.isNotEmpty) {
                                    controller.fetchChapter(
                                      controller.comic.value.linkDetail.split(" ")[0],
                                      int.parse(controller.chapterList.last.linkDetail),
                                    );
                                    final firstChapterNumber = int.parse(controller.chapterList.first.name);
                                    final lastChapterNumber = int.parse(controller.chapterList.last.name);
                                    final targetIndex = firstChapterNumber < lastChapterNumber
                                        ? 0
                                        : controller.chapterList.length - 10;
                                    Get.to(() => ChapDetail(
                                      index: targetIndex,
                                    ));
                                  }
                                },
                              ),
                              GestureDetector(
                                child: Container(
                                  height: ((100.w - 100) * 1.5) + 20,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 40,
                                      width: 150,
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
                                      child: Stack(
                                        children: [
                                          Container(
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                'NEW CHAPTER',
                                                style: TextStyle(color: Colors.white, fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  if (controller.chapterList.isNotEmpty) {
                                      controller.fetchChapter(
                                      controller.comic.value.linkDetail.split(" ")[0],
                                      int.parse(controller.chapterList.first.linkDetail),
                                    );
                                    final firstChapterNumber = int.parse(controller.chapterList.first.name);
                                    final lastChapterNumber = int.parse(controller.chapterList.last.name);
                                    final targetIndex = firstChapterNumber > lastChapterNumber
                                        ? controller.chapterList.length - 1
                                        : 0;
                                    Get.to(() => ChapDetail(
                                      index: targetIndex,
                                    ));
                                  }
                                },
                              ),
                            ],
                          )
                        ],
                      ),

                      /// Title
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 2.h),
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

                      /// Category
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 5.0,
                          children: [
                            ...controller.comic.value.categoryComics.map((category) {
                              return GestureDetector(
                                child: Chip(
                                  label: Text('${category.name}'),
                                  backgroundColor: Colors.black26,
                                ),
                                onTap: () {
                                  // Optionally handle category tap
                                },
                              );
                            }).toList(),
                          ],
                        ),
                      ),

                      /// Description
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 2.h),
                        child: Text(
                          controller.comic.value.description,
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                        ),
                      ),

                      /// Chapter List
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Chapter List',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
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
                            if (controller.isChapterLoading.value) {
                              return Center(child: LoadingWidget());
                            } else if (controller.errorChapterMessage.isNotEmpty) {
                              return Center(
                                child: Text(
                                  controller.errorChapterMessage.value,
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            } else {
                              return ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.all(8),
                                itemCount: controller.chapterList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      controller.fetchChapter(
                                        controller.comic.value.linkDetail.split(" ")[0],
                                        int.parse(controller.chapterList[index].linkDetail),
                                      );
                                      Get.to(() => ChapDetail(
                                        index: index,
                                      ));
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Chap: ${controller.chapterList[index].name}',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                          Text(
                                            '${controller.chapterList[index].dateUpdate}',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              color: Colors.grey.withOpacity(0.5),
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
                      SizedBox(height: 2.h),
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
