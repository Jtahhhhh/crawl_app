
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 2.h),
      margin: EdgeInsets.only(top: 2.h),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 2.5.w),
            width: 0.5.w,
            height: 5.w,
            decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(70)),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w300, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
