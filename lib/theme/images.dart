import 'package:flutter/material.dart';

class MyImages {
  static const google_logo = AssetImage("assets/google_logo.png");
  static const facebook_logo = AssetImage("assets/facebook_white_logo.png");
  static const email = AssetImage("assets/email.png");
  static const home_background = AssetImage("assets/home_background.png");
  static const logout = AssetImage("assets/logout.png");
  static const user_placeholder = AssetImage("assets/user_placeholder.png");
  static const camera = AssetImage("assets/camera.png");
  static const clock_full = AssetImage("assets/clock_full.png");
  static const clock_half = AssetImage("assets/clock_half.png");
  static const clock_empty = AssetImage("assets/clock_empty.png");

  static const take_picture = "assets/take_picture.svg";
  static const cross = "assets/cross.svg";
}

const _mood_icon_width = 30.0;

Icon getMoodIcon(int mood) {
  switch (mood) {
    case 1:
      return Icon(
        Icons.sentiment_very_dissatisfied,
        color: Colors.red,
        size: _mood_icon_width,
      );
    case 2:
      return Icon(
        Icons.sentiment_dissatisfied,
        color: Colors.redAccent,
        size: _mood_icon_width,
      );
    case 3:
      return Icon(
        Icons.sentiment_neutral,
        color: Colors.amber,
        size: _mood_icon_width,
      );
    case 4:
      return Icon(
        Icons.sentiment_satisfied,
        color: Colors.lightGreen,
        size: _mood_icon_width,
      );
    case 5:
      return Icon(
        Icons.sentiment_very_satisfied,
        color: Colors.green,
        size: _mood_icon_width,
      );
    default:
      return null;
  }
}
