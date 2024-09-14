import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class LoadingWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: Colors.red, strokeWidth: 1,),
    );
  }

}