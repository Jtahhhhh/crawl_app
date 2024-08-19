import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../../model/comic.dart';
import '../../../home_page/controller/comicController.dart';

class ChapDetail extends StatelessWidget {
  final ComicsModel comic;
  final List<Chapter> chap;
  int index;

  final ComicController controller = Get.find();
  final ScrollController _scrollController = ScrollController();
  InAppWebViewController? _webViewController;

  ChapDetail({required this.comic, required this.chap, required this.index});

  @override
  Widget build(BuildContext context) {
    final comicLink = comic.linkDetail.split(" ")[0];
    int chapterNumber;
    try {
      chapterNumber = int.parse(chap[index].linkDetail);
    } catch (e) {
      print('Error parsing chapter number: $e');
      return Center(child: Text('Invalid chapter number.'));
    }

    // Fetch the initial chapter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchChapter(comicLink, chapterNumber);
    });
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
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            )),
            // Chapter Content
            Obx(() {
              if (controller.isLoading.value) {
                return Expanded(child: Center(child: CircularProgressIndicator()));
              } else if (controller.errorMessage.isNotEmpty) {
                return Center(
                  child: Text(
                    controller.errorMessage.value,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else {
                String htmlContent = controller.listImg.map((chap) {
                  print(chap);
                  return '<img src="$chap" alt="Chapter Image"/>';
                }).join('');

                return Expanded(
                  child: InAppWebView(
                    initialData: InAppWebViewInitialData(
                      data: '''
                        <html>
                        <body style="background-color: black; color: white;">
                          $htmlContent
                        </body>
                        </html>
                      ''',
                      baseUrl: WebUri(comicLink),
                    ),
                    onWebViewCreated: (controller) {
                      _webViewController = controller;
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
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (index > 0) {
                          index--;
                          await controller.fetchChapter(
                              comicLink, int.parse(chap[index].linkDetail));
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
                      value:controller.currentChapterNumber.value < chap.length
                        ? controller.currentChapterNumber.value
                        : null,
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurpleAccent),
                      dropdownColor: Colors.black,
                      onChanged: (int? newIndex) async {
                        if (newIndex != null && newIndex != index) {
                          index = newIndex;
                          await controller.fetchChapter(
                              comicLink, int.parse(chap[newIndex].linkDetail));
                          controller.currentChapterNumber.value = newIndex;
                        }
                      },
                      items: chap.asMap().entries.map<DropdownMenuItem<int>>((entry) {
                        int idx = entry.key;
                        return DropdownMenuItem<int>(
                          value: idx, // Index used as value
                          child: Text('Chapter ${chap[idx].name}', style: TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (index < chap.length - 1) {
                          index++;
                          await controller.fetchChapter(
                              comicLink, int.parse(chap[index].linkDetail));
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
