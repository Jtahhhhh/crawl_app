import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../model/comic.dart';
import '../../../chap_detail/srceens/chapDetail/chapDetail.dart';
import '../../../home_page/controller/comicController.dart';


class ComicDetail extends StatelessWidget {
  final ComicsModel comic;

  ComicDetail({required this.comic});

  final ComicController controller = Get.put(ComicController());

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchChapterList(int.parse(comic.linkDetail.split(" ")[1]));
    });

    return SafeArea(
      child: Stack(
        children: [

          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(comic.image),
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
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.white),
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
                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 50.h,
                        width: 50.h,
                        alignment: AlignmentDirectional(0, 1.1),
                        margin: EdgeInsets.symmetric(vertical: 5.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: NetworkImage(comic.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 5.h,
                              width: 30.w,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Get.to(ChapDetail(comic: comic, chap: controller.chapterList, index: 0));
                                },
                                child: Text(
                                  "First Chap",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            Container(
                              height: 5.h,
                              width: 30.w,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Get.to(ChapDetail(
                                      comic: comic,
                                      chap: controller.chapterList,
                                      index: controller.chapterList.length - 1));
                                },
                                child: Text(
                                  "Last Chap",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                        margin: EdgeInsets.symmetric(vertical: 2.h),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 2.h),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.sp),
                                  text: comic.title.length >= 20
                                      ? "${comic.title.substring(0, 20)}..."
                                      : comic.title,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Wrap(
                                spacing: 3.w,
                                runSpacing: 2.h,
                                children: [
                                  ...comic.categoryComics.map((category) {
                                    return IntrinsicWidth(
                                      child: IntrinsicHeight(
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            border: Border.all(width: 1),
                                            color: Colors.grey.withOpacity(0.2),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 4.0),
                                            child: RichText(
                                              text: TextSpan(
                                                style: TextStyle(fontSize: 12.sp),
                                                text: category.name,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList()
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 2.h),
                              child: RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                  style: TextStyle(fontSize: 12.sp),
                                  text: comic.description,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                        margin: EdgeInsets.symmetric(vertical: 2.h),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.sp),
                                    text: "Chapter List",
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
                              if (controller.isLoading.value) {
                                return Center(child: CircularProgressIndicator());
                              } else if (controller.errorMessage.isNotEmpty) {
                                return Center(
                                  child: Text(controller.errorMessage.value,
                                      style: TextStyle(color: Colors.white)),
                                );
                              } else {
                                return Container(
                                  height: 30.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.all(8),
                                    itemCount: controller.chapterList.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          print(index);
                                          SchedulerBinding.instance.addPostFrameCallback((_) {
                                            Get.to(ChapDetail(
                                                comic: comic,
                                                chap: controller.chapterList,
                                                index: index));
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                  text: 'Chap: ${controller.chapterList[index].name}'),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                  text: '${controller.chapterList[index].dateUpdate}'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (BuildContext context, int index) => const Divider(),
                                  ),
                                );
                              }
                            }),
                          ],
                        ),
                      ),
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
