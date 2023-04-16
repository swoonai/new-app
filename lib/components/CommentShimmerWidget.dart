import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';

class CommentShimmerWidget extends StatelessWidget {
  const CommentShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child:  Container(
        height: 120.0,
        width: context.width(),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(defaultRadius), color: Colors.white30),
      ),
      baseColor: Colors.grey,
      highlightColor: Colors.black12,
      enabled: true,
      direction: ShimmerDirection.ltr,
      period: Duration(seconds: 1),
    );
  }
}
