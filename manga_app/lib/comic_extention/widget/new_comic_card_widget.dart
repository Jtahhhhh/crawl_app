
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../data/model/model.dart';


class NewComicCard extends StatelessWidget {
  final ComicsModel comic;
  final Function(ComicsModel) onTapItem;
  final Function(ComicsModel,List<Chapter>,int) onTapChapterItem;

  NewComicCard({required this.comic,required this.onTapItem,required this.onTapChapterItem});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async{
        await onTapItem(comic);
      },
      child: Container(
        width: 80.w,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 25.w,
              child: AspectRatio(
                aspectRatio: 3/7,
                child: CachedNetworkImage(
                  imageUrl: comic.image,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14),
                        bottomLeft: Radius.circular(14),
                      ),
                      image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) => Container(
                    child: Stack(
                      children: [
                        Image.asset('assets/images/comicbook2.png', fit: BoxFit.fill,),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(strokeWidth: 1,),
                          ),
                        )
                      ],
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    child: Stack(
                      children: [
                        Image.asset('assets/images/comicbook2.png', fit: BoxFit.fill,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.px,
                  horizontal: 10.px,
                ),
                child: Container(
                  height: 25.w * 7/3 - 16.px,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            comic.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 20.sp,
                            ),
                          ),
                          SizedBox(height: 0.7.h,),
                          Text(
                            comic.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 1.h,),
                          ...comic.chapters.reversed.take(3).toList().asMap().entries.map((chap) {
                            final chapterNumber = RegExp(r'\d+').firstMatch(chap.value.name)?.group(0) ?? "";
                            return InkWell(
                              onTap: () async {
                                await onTapChapterItem(comic,comic.chapters,comic.chapters.length - 1 - chap.key);
                                // await controller.getChapterImg(comic.chapters[comic.chapters.length - 1 - chap.key].linkDetail);
                                // Get.to(() => ChapDetail(
                                //     comic: comic,
                                //     chap: comic.chapters,
                                //     index: comic.chapters.length - 1 - chap.key));
                              },
                              child: Container(
                                color: Colors.transparent,
                                padding: EdgeInsets.all(1.5.px),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Chapter $chapterNumber",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                    ),
                                    Text(
                                      chap.value.dateUpdate,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 14.sp,
                                      ),
                                    ),


                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () async {
                              await onTapChapterItem(comic,comic.chapters,0);
                              // await controller.getChapterImg(comic.chapters[0].linkDetail);
                              // Get.to(() => ChapDetail(
                              //     comic: comic,
                              //     chap: comic.chapters,
                              //     index: 0));
                            },
                            child: Text(
                              "Read Now ＞",
                              style: TextStyle(color: Colors.red, fontSize: 16.sp),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}

