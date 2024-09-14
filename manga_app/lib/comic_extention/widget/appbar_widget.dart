
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TransparentAppBar extends StatelessWidget {
  final String title;
  TransparentAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Container(
        child: Text(
          title,
          style: TextStyle(fontSize: 18.sp, color: Colors.white),
        ),
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
      ),
    );
  }
}