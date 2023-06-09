import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/main.dart';
import 'package:streamit_flutter/network/RestApis.dart';
import 'package:streamit_flutter/screens/HomeScreen.dart';
import 'package:streamit_flutter/screens/OnboardingScreen.dart';
import 'package:streamit_flutter/screens/Signup.dart';
import 'package:streamit_flutter/ui/signin/signin_screen.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';
import 'package:streamit_flutter/utils/Common.dart';
import 'package:streamit_flutter/utils/Constants.dart';
import 'package:streamit_flutter/utils/resources/Images.dart';
import 'package:streamit_flutter/screens/Signup.dart' as signin;

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  void navigationToDashboard() async {
    await 3.seconds.delay;

    mIsLoggedIn = getBoolAsync(isLoggedIn);

    if (getBoolAsync(isFirstTime, defaultValue: true)) {
      await setValue(isFirstTime, false);
      // SignInScreen().launch(context);
      // signin.SignInScreen().launch(context);
      OnBoardingScreen().launch(context, isNewTask: true);
    } else if (mIsLoggedIn) {
      await getUserProfileDetails().then((res) async {
        getDetails(logRes: res, image: res.profileImage.validate())
            .then((value) => HomeScreen().launch(context, isNewTask: true));
      }).catchError((e) async {
        log('Token Refreshing');

        Map req = {
          "username": getStringAsync(USER_EMAIL),
          "password": getStringAsync(PASSWORD),
        };

        await token(req).then((value) {
          // SignInScreen().launch(context);
          HomeScreen().launch(context, isNewTask: true);
        }).catchError((e) {
          logout(context).then((value) {
            // SignInScreen().launch(context);
            HomeScreen().launch(context, isNewTask: true);
          }).catchError((e) {
            log(e.toString());
          });
        });
      });
    } else {
      // SignInScreen().launch(context);
      // signin.SignUpScreen().launch(context);
      HomeScreen().launch(context, isNewTask: true);
    }
  }

  @override
  void initState() {
    super.initState();
    navigationToDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        child: Center(
          child: commonCacheImageWidget(ic_logo, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
