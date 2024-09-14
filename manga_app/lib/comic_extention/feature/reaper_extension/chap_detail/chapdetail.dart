import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import 'package:sizer/sizer.dart';

import '../../../widget/loading.dart';
import '../../../widget/webview/webviewinapp.dart';
import '../comic_details_page/srceen/details.dart';
import '../home_page/controller/controller.dart';

class ChapReaperDetail extends StatelessWidget {
  int index;

  final bool isShowFromDetail;

  final ComicReaperController controller = Get.find();
  final ScrollController _scrollController = ScrollController();
  InAppWebViewController? _webViewController;

  ChapReaperDetail({ required this.index, this.isShowFromDetail = true});


  @override
  Widget build(BuildContext context) {
    //final comicLink = comic.linkDetail.split(" ")[0];
    // try {
    //   chapterNumber = int.parse(chap[index].linkDetail);
    // } catch (e) {
    //   print('Error parsing chapter number: $e');
    //   return Center(child: Text('Invalid chapter number.'));
    // }

    // Fetch the initial chapter
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   controller.fetchChapter(comicLink, chapterNumber);
    // });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Obx(() => Visibility(
              visible: controller.isVisible.value,
              child: AppBar(
                backgroundColor: Colors.black,
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    if (!isShowFromDetail) {
                      Future(
                        () => Get.to(()=> ComicReaperDetail(
                        ))
                      );
                    }
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
                ),
              ),
            )),
            // Chapter Content
            Obx(() {
              if (controller.isImgLoading.value) {
                return Expanded(child: Center(child: LoadingWidget()));
              } else if (controller.errorImgMessage.isNotEmpty) {
                return Center(
                  child: Text(
                    controller.errorImgMessage.value,
                    style: TextStyle(color: Colors.black)
                  ),
                );
              } else {
                print('img link ${controller.listImg}');
                String htmlContent = controller.listImg.map((chap) {
                  return '<img decoding="async" loading="lazy" src="$chap" class="img-fluid" alt="${controller.comic}" />';
                }).join('');

                return Expanded(
                  child: WebViewInApp(
                    data: '''
                      <div class="img">
                        $htmlContent
                      </div>
                    ''',
                    onLoad: (InAppWebViewController controller) {  },
                    onEvent: (Map<String, dynamic> event) {

                    },
                    onLoadSuccess: (InAppWebViewController controller) {
                      _webViewController = controller;
                    },
                    onLoadFail: (String error) {
                      print('error: $error');
                    },
                  ),
                );
              }
            }),
            // Chapter Navigation Controls
            Obx(() {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (controller.currentChapterNumber.value != index) {
                  controller.currentChapterNumber.value = index;
                }
              });
              return Container(
                width: 100.w,
                color: Colors.black,
                padding: EdgeInsets.symmetric(
                  vertical: 1.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (!controller.isReversed.value) {
                          // Regular navigation
                          if (index > 0) {
                            index--;
                            controller.currentChapterNumber.value = index;
                            controller.getChapterImg(controller.chapterList[index].linkDetail, controller.comic.value.linkDetail);
                          }
                        } else {
                          // Reversed navigation
                          if (index < controller.chapterList.length - 1) {
                            index++;
                            controller.currentChapterNumber.value = index;
                            controller.getChapterImg(controller.chapterList[index].linkDetail, controller.comic.value.linkDetail);
                          }
                        }
                      },
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back_ios_new, color: Colors.white),
                          Text("Prev", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    DropdownButton<int>(
                      value: controller.currentChapterNumber.value < controller.chapterList.length
                          ? controller.currentChapterNumber.value
                          : null,
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurpleAccent),
                      dropdownColor: Colors.black,
                      onChanged: (int? newIndex) async {
                        if (newIndex != null && newIndex != index) {
                          index = newIndex;
                          controller.getChapterImg(controller.chapterList[index].linkDetail, controller.comic.value.linkDetail);
                          controller.currentChapterNumber.value = newIndex;
                        }
                      },
                      items: controller.chapterList.asMap().entries.map<DropdownMenuItem<int>>((entry) {
                        int idx = entry.key;
                        return DropdownMenuItem<int>(
                          value: idx,
                          child: Text('${controller.chapterList[idx].name}', style: TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (!controller.isReversed.value) {
                          // Regular navigation
                          if (index < controller.chapterList.length - 1) {
                            index++;
                            controller.currentChapterNumber.value = index;
                            controller.getChapterImg(controller.chapterList[index].linkDetail, controller.comic.value.linkDetail);
                          }
                        } else {
                          // Reversed navigation
                          if (index > 0) {
                            index--;
                            controller.currentChapterNumber.value = index;
                            controller.getChapterImg(controller.chapterList[index].linkDetail, controller.comic.value.linkDetail);
                          }
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Next", style: TextStyle(color: Colors.white)),
                          Icon(Icons.arrow_forward_ios, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),

              );
            }),
          ],
        ),
      ),
    );
  }
}
