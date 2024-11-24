import 'package:flutter/material.dart';

BoxDecoration fancyBackground(bool useDarkTheme) {
  final bgImage = useDarkTheme ? 'bg_pattern_dark' : 'bg_pattern_light';

  return BoxDecoration(
    gradient: LinearGradient(
      stops: [0.0, 0.6, 1.0],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.fromARGB(150, 0, 0, 0),
        Color.fromARGB(10, 0, 0, 0),
        Color.fromARGB(150, 0, 0, 0),
      ],
    ),
    image: DecorationImage(
      repeat: ImageRepeat.repeat,
      image: AssetImage('assets/images/$bgImage.png'),
    ),
  );
}
