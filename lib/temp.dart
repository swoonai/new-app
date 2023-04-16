import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_flutter/utils/AppWidgets.dart';
import 'package:streamit_flutter/utils/resources/Colors.dart';

const AUTH0_DOMAIN = 'elizabethapril.us.auth0.com';
const AUTH0_CLIENT_ID = '72QWJGkh7a1ZrROWUcNLVOqW5nuZC3eS';

const AUTH0_REDIRECT_URI = 'com.iqonic.streamit://login-callback';
const AUTH0_ISSUER = 'https://$AUTH0_DOMAIN';

class TempScreen extends StatefulWidget {
  static String tag = '/tempScreen';


  final name;
  final image;
  final id;

  TempScreen(this.name, this.id, this.image);

  @override
  TempScreenState createState() => TempScreenState();
}

class TempScreenState extends State<TempScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode passFocus = FocusNode();
  FocusNode emailFocus = FocusNode();

  bool passwordVisible = false;
  bool isLoading = false;

  late FlutterAppAuth appAuth;

  @override
  void initState() {
    super.initState();
    setStatusBarColor(Colors.transparent, delayInMilliSeconds: 500);
    appAuth = FlutterAppAuth();
  }

  @override
  void dispose() {
    setStatusBarColor(appBackground);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          commonCacheImageWidget(
            'assets/images/background_ek49.png',
            fit: BoxFit.fill,
            width: context.width(),
            height: context.height(),
          ),
          Container(
              width: context.width(),
              height: context.height(),
              color: Colors.black.withOpacity(0.5)),
          Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Center(
                          child: const Text("Auth0 Details",
                              style: TextStyle(color: Colors.white)),
                        ),
                        SizedBox(height: 20,),
                        SizedBox(
                            child: Profile(
                                name: widget.name, picture: widget.image, id: widget.id)),
                        SizedBox(height: 30),
                        ElevatedButton(onPressed: (){_logout();}, child: Text('Logout', style: TextStyle(color: Colors.black),))
                      ],
                    ),
                  ),
                ).paddingSymmetric(horizontal: 16, vertical: 24),
              ),
            ).center(),
          ),
        ],
      ),
    );
  }


  _logout() async {
   Navigator.pop(context);
  }
}

class Profile extends StatelessWidget {
  final String? name;
  final String? picture;
  final String? id;

  Profile({this.name, this.picture, this.id});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blue, width: 4.0),
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(picture ?? ''),
                )),
          ),
          SizedBox(
            height: 24.0,
          ),
          Text('Name: $name', style: TextStyle(color: Colors.white)),
          SizedBox(
            height: 24.0,
          ),
          Text('Id: $id', style: TextStyle(color: Colors.white)),
          SizedBox(
            height: 48.0,
          ),
        ]);
  }
}
