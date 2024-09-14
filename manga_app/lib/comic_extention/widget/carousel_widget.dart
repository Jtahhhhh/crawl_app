
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import '../data/model/model.dart';


class CarouselSliderWidget extends StatefulWidget {
  final List<ComicsModel> comics;
  final Function(int) onPageChanged;
  final Function(ComicsModel) onTapItem;

  CarouselSliderWidget({required this.comics, required this.onPageChanged,required this.onTapItem});

  @override
  _CarouselSliderWidgetState createState() => _CarouselSliderWidgetState();
}

class _CarouselSliderWidgetState extends State<CarouselSliderWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.comics.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            final comic = widget.comics[index];
            return GestureDetector(
              onTap: () {
                widget.onTapItem(comic);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Column(
                  children: [
                    Flexible(
                      child: CachedNetworkImage(
                        imageUrl: comic.image,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12.0)),
                            image: DecorationImage(
                              alignment: Alignment.topCenter,
                              image: imageProvider,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => Image.asset(
                          'assets/images/comicbook.png',
                          fit: BoxFit.fill,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/comicbook.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          options: CarouselOptions(
            viewportFraction: 0.7,
            aspectRatio: 8 / 10,
            initialPage: 0,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
              widget.onPageChanged(index);
            },
          ),
        ),
        SizedBox(height: 1.5.h,),
        Container(
          width: 70.w,
          padding: EdgeInsets.symmetric(
            vertical: 15.px,
          ),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Column(
            children: [
              Text(
                widget.comics[_currentIndex].title,  // Show title of the currently selected comic
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 0.5.h),
              Text(
                "${
                    widget.comics[_currentIndex].categoryComics
                        .take(3).map((cate) => cate.name).join('・')
                }",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

