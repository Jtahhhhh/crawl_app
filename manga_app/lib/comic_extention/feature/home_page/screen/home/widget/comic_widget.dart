import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../comic_details_page/srceen/comicDetails/details.dart';
import '../../../controller/comicController.dart';


class ComicWidget extends StatelessWidget {
  final ComicController controller = Get.put(ComicController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: Container(
            margin: EdgeInsets.all(20),
            child: CircularProgressIndicator(),
          ),
        );
      } else if (controller.newComics.isEmpty) {
        return Container(
          child: Center(
            child: Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: 'Can\'t load data. Please report to us ',
                  style: TextStyle(letterSpacing: 0.05, height: 1.3),
                ),
                // TextSpan(
                //   text: 'here',
                //   recognizer: TapGestureRecognizer()
                //     ..onTap = () => launchUrlString(
                //       'https://twitter.com/manhwagosite',
                //       mode: LaunchMode.externalApplication,
                //     ),
                //   style: TextStyle(
                //     letterSpacing: 0.05,
                //     height: 1.3,
                //     decoration: TextDecoration.underline,
                //     color: Colors.blue,
                //   ),
                // ),
                TextSpan(
                  text: '.',
                  style: TextStyle(letterSpacing: 0.05, height: 1.3),
                ),
              ]),
            ),
          ),
        );
      } else {
        return Container(
          height: MediaQuery.of(context).size.height / 2,
          child: GridView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(
              right: 16.0,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 1 / 4,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: controller.newComics.length,
            itemBuilder: (BuildContext context, int index) {
              final rate = (index + 1);
              String ratingText = '';
              Color col = Colors.grey;
              if (rate == 1 || rate == 2 || rate == 3) {
                ratingText = '#$rate';
                if (rate == 1) {
                  col = Colors.red;
                }
                if (rate == 2) {
                  col = Colors.yellow;
                }
                if (rate == 3) {
                  col = Colors.blue;
                }
              } else {
                ratingText = '$rate';
              }

              var data = controller.newComics[index];
              return GestureDetector(
                onTap: () {
                  Get.to(() => ComicDetail(comic: controller.newComics[index]));
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              '$ratingText'.padLeft(
                                  ratingText.length == 2 ? 0 : 2, ' '),
                              style: TextStyle(
                                fontSize: 16.0,
                                color: col,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: CachedNetworkImage(
                            imageUrl: data.image,
                            fit: BoxFit.fill,
                            placeholder: (context, url) => Container(
                              height: 200,
                              child: Image.asset('assets/images/comicbook2.png'),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.amber.withOpacity(.5)),
                                color: Colors.grey.withOpacity(.4),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                              ),
                              child: Container(
                                height: 200,
                                child:
                                Image.asset('assets/images/comicbook2.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                data.title,
                                maxLines: 1,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w300),
                              ),
                            ),
                            ...data.chapters.reversed.take(3).map((chapter) {
                              return Container(
                                padding: EdgeInsets.only(left: 10),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        child: Text(
                                         "Chapter ${chapter.name}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        chapter.dateUpdate,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }
    });
  }
}