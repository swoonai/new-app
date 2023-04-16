import 'package:flutter/material.dart';

class CopyrightTextWidget extends StatelessWidget {
  const CopyrightTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.top),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: RichText(
          text: TextSpan(children: [
            TextSpan(
                text: 'Copyright',
                style: TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'RobotoCondensed', fontWeight: FontWeight.w300)),
            TextSpan(
                text: ' Elizabethapril.com ',
                style: TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'RobotoCondensed', fontWeight: FontWeight.w400)),
            TextSpan(
                text: '2022. All Rights Reserved.',
                style: TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'RobotoCondensed', fontWeight: FontWeight.w300)),
          ]),
        ),
      ),
    );
  }
}
