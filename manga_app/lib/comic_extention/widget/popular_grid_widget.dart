import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../data/model/model.dart';

class PopularAllGrid extends StatelessWidget {
  final List<ComicsModel> comics;
  final Function(ComicsModel) onTap;

  PopularAllGrid({required this.comics,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 1.w),
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
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
                                  fontWeight: FontWeight.w300,
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
              onTap: () {
                onTap(data);
                // MyAd.showAD();
                // ComicMotalsController _controller = Get.find();
                // Get.to(() => ComicDetail(comic: data));
              },
            );
          },
        ),
      ),
    );
  }
}