import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/resources/Images.dart';

class LoaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      child: SizedBox(
        width: context.width(),
        height: context.height(),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8, tileMode: TileMode.repeated),
          child: Image.asset(
            ic_loading_gif,
            fit: BoxFit.cover,
            height: 100,
            width: 100,
          ).center(),
        ),
      ),
    );
  }
}
