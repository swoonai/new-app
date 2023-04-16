import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../temp.dart';

const AUTH0_DOMAIN = 'elizabethapril.us.auth0.com';
const AUTH0_CLIENT_ID = '72QWJGkh7a1ZrROWUcNLVOqW5nuZC3eS';

// const AUTH0_REDIRECT_URI = 'com.iqonic.streamit://elizabethapril.us.auth0.com/ios/com.iqonic.streamit/callback';
const AUTH0_REDIRECT_URI = 'com.iqonic.streamit://login-callback';
const AUTH0_ISSUER = 'https://$AUTH0_DOMAIN';

class SignInController extends GetxController {

  final controllerEmail = TextEditingController().obs;
  final controllerPassword = TextEditingController().obs;
  final isPasswordObSecure = true.obs;

  late FlutterAppAuth appAuth;


  // Auth0 Google Login
  googleLogin({Function? callback}) async {
    appAuth = FlutterAppAuth();
    try {
      final AuthorizationTokenResponse? result =
      await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          AUTH0_CLIENT_ID,
          AUTH0_REDIRECT_URI,
          issuer: 'https://$AUTH0_DOMAIN',
          scopes: ['openid', 'profile', 'offline_access'],
          promptValues: ['login'],
        ),
      );
      // final idToken = parseIdToken(result!.idToken.toString());
      final profile = await _getUserDetails(result?.accessToken.toString(), callback); // To get the User Details from Auth0

    } catch (e, s) {
      print('Login error $e-stack:$s');

        errorMessage = e.toString();

    }
  }

  Future<Map> _getUserDetails(String? accessToken, callback) async {
    const url = 'https://$AUTH0_DOMAIN/userinfo';
    final response = await get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      var j = jsonDecode(response.body);

      // Get.to(()=>TempScreen(j['name'], j['picture'], j['sub']));

      // To show the Login Data from Auth0
      callback(TempScreen(j['name'], 'https://${j['picture']}', j['sub']));
      // TempScreen(j['name'], j['picture'], j['sub']).launch(Get.context!);

      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details.');
    }
  }
}