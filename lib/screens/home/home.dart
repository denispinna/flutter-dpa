import 'package:dpa/theme/images.dart';
import 'package:flutter/material.dart';
import 'package:dpa/screens/home/components/home_widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: MyImages.home_background,
            fit: BoxFit.cover,
          ),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: MyImages.home_background, fit: BoxFit.cover),
          ),
          child: Center(child: HomeWidget()),
        ),
      ),
    );
  }
}
