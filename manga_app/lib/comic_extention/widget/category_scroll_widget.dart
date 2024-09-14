
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../data/model/model.dart';

class CategoryScroll extends StatelessWidget {
  final List<CategoryComics> genres;
  final Function(String) onGenreTap;

  CategoryScroll({required this.genres, required this.onGenreTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 1.w + 5),
        child: Wrap(
          spacing: 2.w,
          children: genres.map((genre) {
            return InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 10.px,
                  horizontal: 12.px,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Text(
                  genre.name,
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                ),
              ),
              onTap: () {
                onGenreTap(genre.linkDetail);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
