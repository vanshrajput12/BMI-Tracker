import 'package:flutter/material.dart';

class responsiveScreen extends StatelessWidget {
  const responsiveScreen({super.key, required this.mobile, required this.tablet});

  final Widget mobile;
  final Widget tablet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder:(context,constraints){
          if(constraints.maxWidth <600){
            return mobile;
          }else{
            return tablet;
          }
        },),
    );
  }
}
