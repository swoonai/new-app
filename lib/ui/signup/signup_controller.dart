import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SignUpController extends GetxController {

  final controllerName = TextEditingController().obs;
  final controllerPhoneNo = TextEditingController().obs;
  final controllerEmail = TextEditingController().obs;
  final controllerPassword = TextEditingController().obs;
  final controllerCountry = TextEditingController().obs;
  final isPasswordObSecure = true.obs;
  final isDense = true.obs;

  final imageFile = File('').obs;

  pickImage() {
    final ImagePicker _picker = ImagePicker();
    // Pick an image
    _picker.pickImage(source: ImageSource.gallery).then((value) {
      imageFile.value = File(value?.path??'');
    });
    // Capture a photo

  }
}