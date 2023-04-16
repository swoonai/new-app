import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:streamit_flutter/ui/custom_widgets/copyright_text_widget.dart';
import 'package:streamit_flutter/ui/custom_widgets/custom_text.dart';
import 'package:streamit_flutter/ui/user_selection/user_selection_controller.dart';
import 'package:streamit_flutter/utils/Constants.dart';
import '../../utils/resources/Colors.dart';
import '../custom_widgets/custom_button.dart';

class UserSelectionScreen extends StatefulWidget {

  @override
  State<UserSelectionScreen> createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  var list = [
    {
      'name': 'Laura\nBernshtein',
      'profile_pic': 'image_1.png',
      'is_selected': true
    },
    {
      'name': 'Daniel\nFridman',
      'profile_pic': 'image_2.png',
      'is_selected': false
    },
    {
      'name': 'Zura\nMilchenko',
      'profile_pic': 'image_3.png',
      'is_selected': false
    },
    {
      'name': 'Maya\nLakoba',
      'profile_pic': 'image_4.png',
      'is_selected': false
    },
    {
      'name': 'Merab\nVacheishvili',
      'profile_pic': 'image_5.png',
      'is_selected': false
    }
  ];
  var prevIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: true,
      body: Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: MediaQuery.of(context).viewPadding.top,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            CustomText('Who is watching?',
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'RobotoCondensed',
                fontWeight: FontWeight.w300),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText('EA', color: Colors.white, fontSize: 38),
                    SizedBox(height: 10),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: 'Hi Daniel Fridman, This is a ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w100)),
                        TextSpan(
                            text: 'Free',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w400)),
                        TextSpan(
                            text:
                                ' account, with this subscription 1 users have the possibility to watch 3 movies monthly.',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.w100)),
                      ]),
                    ),
                    SizedBox(height: 10),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                            width: 40,
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.white,
                            ))),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SvgPicture.asset('${imagePathSvg}edit.svg'),
                        CustomText(' Edit user',
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'RobotoCondensed'),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 100,
                      child: ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (_, int index) => _items(index),
                          scrollDirection: Axis.horizontal),
                    ),
                    SizedBox(height: 10),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                            width: 40,
                            child: Divider(
                              thickness: 0.5,
                              color: Colors.white,
                            ))),
                    SizedBox(height: 10),
                    CustomButton('ENTER', onClick: () {
                      // if (_formKey.currentState!.validate()) {}
                    })
                  ],
                ),
              ),
            ),
            CopyrightTextWidget(),
          ],
        ),
      ),
    );
  }

  _items(int index) => InkWell(
    onTap: (){
      setState(() {
        list[prevIndex]['is_selected'] = false;
        list[index]['is_selected'] = true;
        prevIndex = index;
      });
    },
    child: Padding(
          padding: EdgeInsets.only(right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 60,
                width: 60,
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:  Colors.black,
                    border: Border.all(color: Colors.white, width: list[index]['is_selected'] == true ? 3: 1)
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(200)),
                    child: Image.asset(
                        'assets/images/png/${list[index]['profile_pic']}')),
              ),
              CustomText(list[index]['name'].toString(),
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: list[index]['is_selected'] == true
                      ? FontWeight.w500
                      : FontWeight.w300,
                  fontFamily: 'RobotoCondensed')
            ],
          ),
        ),
  );
}
